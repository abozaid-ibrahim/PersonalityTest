//
//  RXViewController.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxDataSources
import RxSwift
import UIKit

class RXViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: QuestionsTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = QuestionsTableViewModel(category: QCategory.lifestyle)
        tableView.registerNib(RxTableViewCell.self)
        tableView.registerNib(SubmitTableCell.self)
        tableView.registerNib(RangeTableCell.self)
        viewModel.loadData()
        let dataSource = RxTableViewSectionedReloadDataSource<QuestionSectionModel>(
            configureCell: { _, tableView, indexPath, item in

                switch item.cellType {
                case .range:
                    let cell: RangeTableCell = tableView.dequeueReusableCell(withIdentifier: RangeTableCell.identifier, for: indexPath) as! RangeTableCell
//                    cell.nameLbl.text = (item as! SelectableAnswerModel).option
                    return cell
                case .text:
                    let cell: RxTableViewCell = tableView.dequeueReusableCell(withIdentifier: RxTableViewCell.identifier, for: indexPath) as! RxTableViewCell
                    cell.nameLbl.text = (item as! SelectableAnswerModel).option
                    return cell
                case .submit:
                    let cell: SubmitTableCell = tableView.dequeueReusableCell(withIdentifier: SubmitTableCell.identifier, for: indexPath) as! SubmitTableCell
//                    cell.nameLbl.text = (item as! SubmitButtonModel)
                    return cell
                }

            },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].question
            }
        )
        viewModel.questions.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.itemSelected.bind(onNext: itemSelected).disposed(by: disposeBag)
        tableView.rx.itemDeselected.bind(onNext: itemDeSelected).disposed(by: disposeBag)
    }

    func itemSelected(index: IndexPath) {
        viewModel.itemSelected(index: index)
    }

    func itemDeSelected(index: IndexPath) {
        viewModel.itemDeSelected(index: index)
    }
}

