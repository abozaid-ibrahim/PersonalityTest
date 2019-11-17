//
//  DataSourceModels.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct QuestionSectionModel {
    var question: String?

    var items: [Item]
    var answered: Bool = false
    mutating func isAnswered(ans: Bool) {
        answered = ans
    }
}

extension QuestionSectionModel: SectionModelType {
    typealias Item = AnswerRowModel

    init(original: QuestionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SelectableAnswerModel: AnswerRowModel, IdentifiableType {
    var cellType: OptionCellType { .text }

    typealias Identity = String
    var identity: String {
        return "\(sectionId)_\(option)"
    }

    let sectionId: Int
    var option: String
    var conditional: RangeAnswerModel?
    mutating func setName(_ s: String) {
        option = s
    }
}

struct RangeAnswerModel: AnswerRowModel, IdentifiableType {
    var cellType: OptionCellType { .range }

    typealias Identity = String
    var identity: String {
        return "\(sectionId)_\(answerId)_\(title)"
    }

    let sectionId: Int
    let answerId: Int
    var title: String?
}

struct SubmitButtonModel: AnswerRowModel, IdentifiableType {
    var cellType: OptionCellType { .submit }

    typealias Identity = String
    var identity: String {
        return "\(sectionId)_\(title)"
    }

    let sectionId: Int
    var title: String {
        "Submit"
    }
}

protocol AnswerRowModel {
    var sectionId: Int { get }
    var cellType: OptionCellType { get }
}

enum OptionCellType {
    case submit, range, text
}
