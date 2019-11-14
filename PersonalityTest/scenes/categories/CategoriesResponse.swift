//
//  CategoriesResponse.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

// MARK: - CategoriesResponse

struct CategoriesResponse: Codable {
    let categories: [Category]?
    let questions: [Question]?
}

enum Category: String, Codable {
    case hardFact = "hard_fact"
    case introversion
    case lifestyle
    case passion
}

// MARK: - Question

struct Question: Codable {
    let question: String?
    let category: Category?
    let questionType: QuestionQuestionType?

    enum CodingKeys: String, CodingKey {
        case question
        case category
        case questionType = "question_type"
    }

}

// MARK: - QuestionQuestionType

struct QuestionQuestionType: Codable {
    let type: QTypeEnum?
    let options: [String]?
    let condition: Condition?
}

// MARK: - Condition

struct Condition: Codable {
    let predicate: Predicate?
    let ifPositive: IfPositive?
}

// MARK: - IfPositive

struct IfPositive: Codable {
    let question: String?
    let category: Category?
    let questionType: IfPositiveQuestionType?

    enum CodingKeys: String, CodingKey {
        case question
        case category
        case questionType = "question_type"
    }
}

// MARK: - IfPositiveQuestionType

struct IfPositiveQuestionType: Codable {
    let type: QTypeEnum?
    let range: Range?
}

// MARK: - Range

struct Range: Codable {
    let from: Int?
    let to: Int?
}

// MARK: - Predicate

struct Predicate: Codable {
    let exactEquals: [String]?
}

enum QTypeEnum: String, Codable, Equatable {
    case singleChoice = "single_choice"
    case singleChoiceConditional = "single_choice_conditional"
    case numberRange = "number_range"
}
