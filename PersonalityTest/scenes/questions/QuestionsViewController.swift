//
//  QuestionsViewController.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxOptional
import RxSwift
import UIKit

final class QuestionsViewController: UIViewController, Loadable {
    @IBOutlet private var questionsTable: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: QuestionsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindToViewModel()
        viewModel.loadData()
    }
}

// MARK: QuestionsViewController (Private)

private extension QuestionsViewController {
    func configureTableView() {
        questionsTable.registerNib(QuestionTableCell.self)
        questionsTable.seperatorStyle()
    }

    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        /// datasource

        viewModel.questions.bind(onNext: setDataSource(sections:)).disposed(by: disposeBag)

        /// delegate
//        questionsTable.rx.itemSelected.bind(onNext: viewModel.answerQuestions(of:)).disposed(by: disposeBag)
//        questionsTable.rx.itemDeselected.bind(onNext: viewModel.removeAnswer(of:)).disposed(by: disposeBag)
    }

    func setDataSource(sections: [QuestionSectionModel]) {
        let _dataSource = dataSource()
        let initialState = SectionedTableViewState(sections: sections)

        Observable.of(viewModel.conditionalQuestion, viewModel.hideQuestion)
            .merge()
            .scan(initialState) { (state: SectionedTableViewState, command: TableViewEditingCommand) -> SectionedTableViewState in
                state.execute(command: command)
            }
            .startWith(initialState)
            .map {
                $0.sections
            }
            .share(replay: 1)
            .bind(to: questionsTable.rx.items(dataSource: _dataSource))
            .disposed(by: disposeBag)
    }

    func dataSource() -> RxTableViewSectionedAnimatedDataSource<QuestionSectionModel> {
        return RxTableViewSectionedAnimatedDataSource(
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: { dataSource, table, idxPath, item in
                switch dataSource[idxPath] {
                    case "let .ImageSectionItem(image, title)":
                        let cell: QuestionTableCell = table.dequeueReusableCell(withIdentifier: String(describing: QuestionTableCell.self), for: idxPath) as! QuestionTableCell
                        cell.setData(item)
                        return cell
                    default:
                        let cell: QuestionTableCell = table.dequeueReusableCell(withIdentifier: String(describing: QuestionTableCell.self), for: idxPath) as! QuestionTableCell
                        cell.answerChanged.subscribe(onNext: { [unowned self] value in
                            value ? self.viewModel.answerQuestions(of: idxPath) : self.viewModel.removeAnswer(of: idxPath)
                        }).disposed(by: cell.disposeBag)
                        cell.setData(item)
                        return cell
                }

            },
            titleForHeaderInSection: { ds, section -> String? in
                ds[section].question
            }
        )
    }
}
