//
//  ListViewController.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/13/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Eureka
import RxSwift
import UIKit

class ListViewController: FormViewController {
    var viewModel: QuestionsViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.loadData()
//        viewModel.questions.bind(onNext: data(xx:)).disposed(by: disposeBag)

        let continents = ["Africa", "Antarctica", "Asia", "Australia", "Europe", "North America", "South America"]

        form +++ SelectableSection<ImageCheckRow<String>>() { section in
            section.header = HeaderFooterView(title: "Where do you live?")
        }

        for option in continents {
            form.last! <<< ImageCheckRow<String>(option) { lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }
        }

        let oceans = ["Arctic", "Atlantic", "Indian", "Pacific", "Southern"]

        form +++ SelectableSection<ImageCheckRow<String>>("And which of the following oceans have you taken a bath in?", selectionType: .multipleSelection)
        for option in oceans {
            form.last! <<< ImageCheckRow<String>(option) { lrow in
                lrow.title = option
                lrow.selectableValue = option
                lrow.value = nil
            }.cellSetup { cell, _ in
                cell.trueImage = UIImage(named: "selected")!
                cell.falseImage = UIImage(named: "unselected")!
                cell.accessoryType = .checkmark
            }
        }
    }

    override func valueHasBeenChanged(for row: BaseRow, oldValue: Any?, newValue: Any?) {
        if row.section === form[0] {
            print("Single Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRow()?.baseValue ?? "No row selected")")
            row.select()
        }
        else if row.section === form[1] {
            print("Mutiple Selection:\((row.section as! SelectableSection<ImageCheckRow<String>>).selectedRows().map { $0.baseValue })")
             row.deselect()
        }
    }
}
