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
        let dataSource = RxTableViewSectionedReloadDataSource<QuestionSectionModel>(
            configureCell: { _, tableView, indexPath, item in
                let cell: QuestionTableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuestionTableCell.self), for: indexPath) as! QuestionTableCell
                cell.setData(item)
                return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].question
        }
        
        viewModel.questions
            .bind(to: questionsTable.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        /// delegate
        //        questionsTable.rx.modelSelected(Question.self).bind(onNext: viewModel.ans.disposed(by: disposeBag)
    }
}
