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
    var items: [AnswerCellData]
    let condition: Condition?
    let type: TypeEnum?
     var answerSubmitted:Bool = false
    var answer: [String] = []
}

extension QuestionSectionModel: AnimatableSectionModelType {
    var identity: String {
        self.question
    }
    
    typealias Identity = String
    
    
    typealias Item = AnswerCellData

    init(original: QuestionSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
struct AnswerCellData:IdentifiableType,Equatable{
    static func == (lhs: AnswerCellData, rhs: AnswerCellData) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var identity: String{
        option
    }
    typealias Identity = String
    let option:String
    var isSelected: Bool = false
    let range: Range? = nil
    var cellType:AnswerCellType = .optionTextCell
}
enum AnswerCellType{
    case submitCell(state:Bool)
    case optionTextCell
    case optionRange
    
}
