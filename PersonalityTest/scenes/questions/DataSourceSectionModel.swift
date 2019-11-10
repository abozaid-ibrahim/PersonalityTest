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
    public let condition: Condition?
    public let type: TypeEnum?
}

extension QuestionSectionModel: SectionModelType {
    typealias Item = String

    init(original: QuestionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
