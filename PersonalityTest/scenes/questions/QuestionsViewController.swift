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
        questionsTable.separatorStyle = .singleLine
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: questionsTable.bounds.width, height: 50))
        customView.backgroundColor = UIColor.darkGray
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: questionsTable.bounds.width - CGFloat(20.0), height: 50))
        button.titleLabel?.textAlignment = .center
        
        button.setTitle("Submit All", for: .normal)
        button.rx.tap.bind(onNext: viewModel.submitAll(sender:)).disposed(by: disposeBag)
        customView.addSubview(button)
        questionsTable.tableFooterView = customView
    }

    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        /// datasource

        viewModel.questions.bind(onNext: setDataSource(sections:)).disposed(by: disposeBag)
        
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
            configureCell: { ds, table, idxPath, item in
                switch ds[idxPath].range {
                case .none:
                    let cell: QuestionTableCell = table.dequeueReusableCell(withIdentifier: String(describing: QuestionTableCell.self), for: idxPath) as! QuestionTableCell
                    cell.answerChanged.subscribe(onNext: { [unowned self] value in
                        value ? self.viewModel.answerQuestions(of: idxPath) : self.viewModel.removeAnswer(of: idxPath)
                    }).disposed(by: cell.disposeBag)
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
            },
            titleForFooterInSection: { _, _ in
                "Submit"
            }
        )
    }
}
