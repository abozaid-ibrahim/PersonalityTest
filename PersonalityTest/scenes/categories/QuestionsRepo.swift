//
//  QuestionsRepo.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
final class QuestionsRepo{
    
    func loadCategories()->[Category]{
        let data  = Bundle.main.decode(CategoriesResponse.self, from: "questions.json")
        return data.categories ?? []
    }
    func loadQuestions()->[Question]{
        let data  = Bundle.main.decode(CategoriesResponse.self, from: "questions.json")
        return data.questions ?? []
    }
}

