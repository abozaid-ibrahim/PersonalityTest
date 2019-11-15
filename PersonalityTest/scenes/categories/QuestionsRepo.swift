//
//  QuestionsRepo.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
protocol QuestionsRepository {
    func loadQuestions() -> [Question]
    func loadCategories() -> [QCategory]
}

final class QuestionsRepo: QuestionsRepository {
    func loadCategories() -> [QCategory] {
        let data = Bundle.main.decode(CategoriesResponse.self, from: "questions.json")
        return data.categories ?? []
    }

    func loadQuestions() -> [Question] {
        let data = Bundle.main.decode(CategoriesResponse.self, from: "questions.json")
        return data.questions ?? []
    }
}
