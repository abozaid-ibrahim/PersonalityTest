//
//  DataSourceSectionModel.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift

struct QuestionSectionModel {
    var question: String
    var items: [Item]
    let condition: Condition?
    let type: TypeEnum?
    var answer: [String] = []
}

extension QuestionSectionModel: AnimatableSectionModelType {
    var identity: String {
        self.question
    }
    
    typealias Identity = String
    
    
    typealias Item = String

    init(original: QuestionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
