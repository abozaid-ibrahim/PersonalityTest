//
//  QuestionsViewModel.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxOptional
import RxSwift

protocol QuestionsViewModel {
    var category: QCategory { get }
    var showProgress: Observable<Bool> { get }
    var questions: Observable<[Question]> { get }
    var error: Observable<Error> { get }
    var allIsAnswered: Bool { get }
    func questionIsAnswered(index: IndexPath) -> Bool
    mutating func answerQuestions(answered: Bool, for index: IndexPath)
    mutating func loadData()
    func submitAll()
}

struct QuestionsListViewModel: QuestionsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let dataRepository: QuestionsRepository
    private let _questions = PublishSubject<[Question]>()
    private let _showProgress = PublishSubject<Bool>()
    private let _error = PublishSubject<Error>()
    private(set) var category: QCategory
    private var questionsList: [Question] = []

    // MARK: Observers

    var showProgress: Observable<Bool> {
        return _showProgress.asObservable()
    }

    var questions: Observable<[Question]> {
        return _questions.asObservable()
    }

    var error: Observable<Error> {
        return _error.asObservable()
    }

    var allIsAnswered: Bool {
        return questionsList.allSatisfy { $0.answered }
    }

    init(repo: QuestionsRepository = QuestionsRepo(), category: QCategory) {
        dataRepository = repo
        self.category = category
    }

    mutating func loadData() {
        questionsList = dataRepository.loadQuestions()
            .filter { $0.category == Optional<QCategory>.some(category) }
        _questions.onNext(questionsList)
    }

    func questionIsAnswered(index: IndexPath) -> Bool {
        return questionsList[index.section].answered
    }

    mutating func answerQuestions(answered: Bool, for index: IndexPath) {
        questionsList[index.section].setAnswered(answered)
    }

    func submitAll() {
        ///todo, should send all submitted data to server
    }
}
