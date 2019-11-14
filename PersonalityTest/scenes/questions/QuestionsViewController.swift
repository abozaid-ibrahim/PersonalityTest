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
        self.tableView.sectionFooterHeight = 1
        self.title = viewModel.category.rawValue.capitalized
        bindToViewModel()
        viewModel.loadData()
    }
}

// MARK: QuestionsViewController (ViewBuilder)

private extension QuestionsViewController {
    var conditionalRowTag: String { "afasdfkasdjfkasdf" }
    func setDataSource(sections: [Question]) {
        for question in sections.enumerated() {
            insertSection(for: question.element, question.offset)
        }
        form +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Submit All"
            }
            .onCellSelection { [weak self] cell, _ in
                // validator
                self?.submitAll()
                cell.backgroundColor = .lightGray
                cell.isUserInteractionEnabled = false
            }
    }

    func insertSection(for question: Question, _ sIndex: Int) {
        form +++ SelectableSection<ImageCheckRow<String>>() { section in
            section.header = HeaderFooterView(title: question.question)
        }
        let options = question.questionType?.options ?? []
        for index in 0..<options.count {
            let option = options[index]
            let uid = "\(question.question ?? "")_\(option)_\(sIndex)_\(index)"
            form.last! <<< ImageCheckRow<String>(uid) { lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }.onChange { row in
                if row.value == nil { // deselect
                    row.section?.removeAll(where: { $0.tag == .some(self.submitRowTag(for: question.question, row.title, index: index)) })
                    row.section?.allRows
                        .filter { $0.tag == .some(self.conditionalRowTag) }
                        .forEach { $0.baseCell.height = { 0 } }

                } else { // select
                    if question.questionType?.type == QTypeEnum.singleChoiceConditional {
                        if question.questionType?.condition?.predicate.value?.exactEquals == [row.value!] {
                            row.section?.allRows[row.indexPath!.row + 1].baseCell.height = { 60 }
                        }
                    }
                    self.addSubmitButton(for: row, question.question, row.value, index: IndexPath(row: index, section: sIndex))
                }
            }

            appendConditionalAnswerCell(question)
        }
    }

    func addSubmitButton(for row: ImageCheckRow<String>, _ question: String?, _ title: String?, index: IndexPath) {
        row.section! <<< ButtonRow { (row: ButtonRow) -> Void in
            row.title = "Submit"
            row.tag = submitRowTag(for: question, title, index: index.row)
        }
        .onCellSelection { [weak self] cell, row in
            self?.viewModel.answerQuestions(of: index)
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            cell.isUserInteractionEnabled = false
        }
    }

    func appendConditionalAnswerCell(_ question: Question?) {
        guard let qst = question?.questionType,
            let type = qst.type,
            let range = qst.condition?.ifPositive?.questionType?.range else { return }
        if case QTypeEnum.singleChoiceConditional = type {
            form.last! <<< SliderRow {
                //                        $0.title = question?.questionType?.condition?.
                $0.value = Float(range.from ?? 0)
                $0.tag = conditionalRowTag
            }.cellSetup { cell, _ in
                cell.height = { 0 }
            }
            //
        }
    }
}

// MARK: QuestionsViewController (Private)

private extension QuestionsViewController {
    func submitAnswers(sender: Any) {
        viewModel.submitAll(sender: sender)
    }

    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        viewModel.questions.bind(onNext: setDataSource(sections:)).disposed(by: disposeBag)
    }

    func submitAll() {
        print(#function)
    }

   

    func submitRowTag(for q: String?, _ opt: String?, index: Int) -> String {
        return "\(q ?? "")_\(opt ?? "")_\(index)"
    }
}
