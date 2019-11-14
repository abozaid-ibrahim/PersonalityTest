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
    var category: Category{get}
    var showProgress: Observable<Bool> { get }
    var questions: Observable<[Question]> { get }
    var error: Observable<Error> { get }
    func answerQuestions(of index: IndexPath)
    func loadData()
    func submitAll(sender: Any)
}

final class QuestionsListViewModel: QuestionsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let dataRepository: QuestionsRepo
    private let _questions = PublishSubject<[Question]>()
    private let _showProgress = PublishSubject<Bool>()
    private let _error = PublishSubject<Error>()
    private(set) var category: Category

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

    init(repo: QuestionsRepo = QuestionsRepo(), category: Category) {
        self.dataRepository = repo
        self.category = category
    }

    func loadData() {
        let xxx = dataRepository.loadQuestions()
            .filter { $0.category == Optional<Category>.some(category) }

        _questions.onNext(xxx)
    }

    func answerQuestions(of index: IndexPath) {
        /// should change in the data and send them to server
    }

    func submitAll(sender: Any) {
        ///todo
    }
}
