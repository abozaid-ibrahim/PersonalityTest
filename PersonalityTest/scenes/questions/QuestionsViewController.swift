//
//  QuestionsViewController.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Eureka
import RxCocoa
import RxOptional
import RxSwift
import UIKit

final class QuestionsViewController: FormViewController, Loadable {
    private var disposeBag = DisposeBag()
    var viewModel: QuestionsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 1
        title = viewModel.category.rawValue.capitalized
        bindToViewModel()
        viewModel.loadData()
    }
}

// MARK: QuestionsViewController (ViewBuilder)

private extension QuestionsViewController {
    var submitted: UIColor { UIColor.green.withAlphaComponent(0.3) }
    func setDataSource(sections: [Question]) {
        for question in sections.enumerated() {
            insertSection(for: question.element, in: question.offset)
        }
        form +++ Section()
            <<< ButtonRow() { [weak self] row in
                guard let self = self else { return }
                row.title = "Submit All"
                let ruleRequiredViaClosure = RuleClosure<String> { _ in
                    self.viewModel.allIsAnswered ? nil : ValidationError(msg: "Field required!")
                }
                row.add(rule: ruleRequiredViaClosure)
                row.validationOptions = .validatesOnDemand
            }.cellUpdate { cell, row in
                cell.backgroundColor = row.isValid ? .white : UIColor.red.withAlphaComponent(0.3)
            }.onCellSelection { _, row in
                row.validate()
            }
    }

    func insertSection(for question: Question, in sIndex: Int) {
        form +++ SelectableSection<ImageCheckRow<String>>() { section in
            section.header = HeaderFooterView(title: question.question)
        }
        let options = question.answers?.options ?? []
        for index in 0 ..< options.count {
            let option = options[index]
            let uid = "\(question.question ?? "")_\(option)_\(sIndex)_\(index)"
            form.last! <<< ImageCheckRow<String>(uid) { lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }.onChange { [weak self] row in
                self?.onOptionSelected(question, row: row, sIndex: sIndex, index: index)
            }
        }
    }

    func onOptionSelected(_ question: Question, row: ImageCheckRow<String>, sIndex: Int, index: Int) {
        if row.value == nil { /// deselect
            row.section?.removeAll(where: { $0.tag == .some(self.submitRowTag(for: question.question, row.title, index: index)) })
            row.section?.removeAll(where: { $0.tag == .some(self.conditionalRowTag(IndexPath(row: index, section: sIndex))) })
        } else { // select
            appendConditionalAnswerCell(row.section!, current: row.value ?? "", question, IndexPath(row: index, section: sIndex))
            addSubmitButton(for: row, question.question, row.value, index: IndexPath(row: index, section: sIndex))
        }
        viewModel.answerQuestions(answered: row.value != nil, for: IndexPath(row: index, section: sIndex))
    }

    func addSubmitButton(for row: ImageCheckRow<String>, _ question: String?, _ title: String?, index: IndexPath) {
        row.section! <<< ButtonRow { [weak self] row in
            guard let self = self else { return }
            row.title = "Submit"
            row.tag = submitRowTag(for: question, title, index: index.row)
            let ruleRequiredViaClosure = RuleClosure<String> { _ in
                if self.viewModel.questionIsAnswered(index: index) {
                    self.viewModel.answerQuestions(answered: true, for: index)
                    row.baseCell.backgroundColor = self.submitted
                    return nil
                } else {
                    return ValidationError(msg: "Field required!")
                }
            }
            row.add(rule: ruleRequiredViaClosure)
            row.validationOptions = .validatesOnDemand
        }.onCellSelection { _, row in
            row.validate()
        }.cellUpdate {[unowned self] _, row in
            row.baseCell.backgroundColor = (row.isValid && self.viewModel.questionIsAnswered(index: index)) ? self.submitted : .white
        }
    }

    func appendConditionalAnswerCell(_ cell: Section, current: String, _ question: Question?, _ index: IndexPath) {
        guard let options = question?.answers,
            let type = options.type,
            let secondQ = options.condition?.ifPositive,
            let range = secondQ.questionType?.range,
            let required = options.condition?.predicate?.exactEquals?.last else {
            return
        }
        guard required == current else {
            return
        }
        if case QTypeEnum.singleChoiceConditional = type {
            cell <<< OptionSliderRow {
                $0.cellProvider = CellProvider<SliderTableCell>(nibName: "SliderTableCell", bundle: Bundle.main)
                $0.tag = conditionalRowTag(index)
            }.cellSetup { cell, _ in
                cell.setData(min: Float(range.from ?? 0), max: Float(range.to ?? 0), title: secondQ.question)
            }
        }
    }
}

// MARK: QuestionsViewController (Private)

private extension QuestionsViewController {
    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.questions.bind(onNext: setDataSource(sections:)).disposed(by: disposeBag)
    }

    func submitRowTag(for q: String?, _ opt: String?, index: Int) -> String {
        return "\(q ?? "")_\(opt ?? "")_\(index)"
    }

    func conditionalRowTag(_ index: IndexPath) -> String {
        return "#\(index.section)_A_\(index.row)"
    }
}
