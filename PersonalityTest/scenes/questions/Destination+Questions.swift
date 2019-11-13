//
//  Destination+Questions.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import UIKit
extension Destination {
    func getQuestionsView(for cat: Category) -> UIViewController {
        let questionsView = ListViewController()
        questionsView.viewModel = QuestionsListViewModel(category: cat)
        return questionsView
    }
}
