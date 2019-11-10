//
//  CategoriesResponse.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

// MARK: - CategoriesResponse
public struct CategoriesResponse: Codable {
    public let categories: [Category]?
    public let questions: [Question]?

    enum CodingKeys: String, CodingKey {
        case categories = "categories"
        case questions = "questions"
    }

    public init(categories: [Category]?, questions: [Question]?) {
        self.categories = categories
        self.questions = questions
    }
}

public enum Category: String, Codable {
    case hardFact = "hard_fact"
    case introversion = "introversion"
    case lifestyle = "lifestyle"
    case passion = "passion"
}

// MARK: - Question
public struct Question: Codable {
    public let question: String?
    public let category: Category?
    public let questionType: QuestionQuestionType?

    enum CodingKeys: String, CodingKey {
        case question = "question"
        case category = "category"
        case questionType = "question_type"
    }

    public init(question: String?, category: Category?, questionType: QuestionQuestionType?) {
        self.question = question
        self.category = category
        self.questionType = questionType
    }
}

// MARK: - QuestionQuestionType
public struct QuestionQuestionType: Codable {
    public let type: TypeEnum?
    public let options: [String]?
    public let condition: Condition?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case options = "options"
        case condition = "condition"
    }

    public init(type: TypeEnum?, options: [String]?, condition: Condition?) {
        self.type = type
        self.options = options
        self.condition = condition
    }
}

// MARK: - Condition
public struct Condition: Codable {
    public let predicate: Predicate?
    public let ifPositive: IfPositive?

    enum CodingKeys: String, CodingKey {
        case predicate = "predicate"
        case ifPositive = "if_positive"
    }

    public init(predicate: Predicate?, ifPositive: IfPositive?) {
        self.predicate = predicate
        self.ifPositive = ifPositive
    }
}

// MARK: - IfPositive
public struct IfPositive: Codable {
    public let question: String?
    public let category: Category?
    public let questionType: IfPositiveQuestionType?

    enum CodingKeys: String, CodingKey {
        case question = "question"
        case category = "category"
        case questionType = "question_type"
    }

    public init(question: String?, category: Category?, questionType: IfPositiveQuestionType?) {
        self.question = question
        self.category = category
        self.questionType = questionType
    }
}

// MARK: - IfPositiveQuestionType
public struct IfPositiveQuestionType: Codable {
    public let type: TypeEnum?
    public let range: Range?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case range = "range"
    }

    public init(type: TypeEnum?, range: Range?) {
        self.type = type
        self.range = range
    }
}

// MARK: - Range
public struct Range: Codable {
    public let from: Int?
    public let to: Int?

    enum CodingKeys: String, CodingKey {
        case from = "from"
        case to = "to"
    }

    public init(from: Int?, to: Int?) {
        self.from = from
        self.to = to
    }
}

// MARK: - Predicate
public struct Predicate: Codable {
    public let exactEquals: [String]?

    enum CodingKeys: String, CodingKey {
        case exactEquals = "exactEquals"
    }

    public init(exactEquals: [String]?) {
        self.exactEquals = exactEquals
    }
}

public enum TypeEnum: String, Codable,Equatable {
    case singleChoice = "single_choice"
    case singleChoiceConditional = "single_choice_conditional"
    case numberRange = "number_range"
}
