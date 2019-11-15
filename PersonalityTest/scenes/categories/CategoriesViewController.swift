//
//  CategoriesViewController.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import RxCocoa
import RxOptional
import RxSwift
import UIKit

final class CategoriesViewController: UIViewController, Loadable {
    @IBOutlet private var categoriesTable: UITableView!
    private let disposeBag = DisposeBag()
    var viewModel: CategoriesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        configureTableView()
        bindToViewModel()
        viewModel.loadData()
    }
}

// MARK: CategoriesViewController (Private)

private extension CategoriesViewController {
    func configureTableView() {
        categoriesTable.registerNib(CategoryTableCell.self)
        categoriesTable.seperatorStyle()
    }

    func bindToViewModel() {
        viewModel.showProgress
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: showLoading(show:)).disposed(by: disposeBag)
        /// datasource
        viewModel.categories
            .bind(to: categoriesTable.rx.items(cellIdentifier:
                String(describing: CategoryTableCell.self), cellType: CategoryTableCell.self)) { _, model, cell in
                cell.setData(model)
            }.disposed(by: disposeBag)
        /// delegate
        categoriesTable.rx.modelSelected(QCategory.self).bind(onNext: viewModel.showQuestionsList(of:)).disposed(by: disposeBag)
    }
}
