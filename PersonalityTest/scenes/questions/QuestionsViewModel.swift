//
//  QuestionsViewModel.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation

import Foundation
import RxOptional
import RxSwift

protocol QuestionsViewModel {
    var showProgress: Observable<Bool> { get }
    var questions: Observable<[Question]> { get }
    var error: Observable<Error> { get }
    func answerQuestions(of question: Question)
    func loadData()
}

final class QuestionsListViewModel: QuestionsViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let dataRepository: QuestionsRepo
    private let _questions = PublishSubject<[Question]>()
    private let _showProgress = PublishSubject<Bool>()
    private let _error = PublishSubject<Error>()
    private var category: Category

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

    /// initializier
    /// - Parameter apiClient: network handler
    init(repo: QuestionsRepo = QuestionsRepo(), category: Category) {
        self.dataRepository = repo
        self.category = category
    }

    func loadData() {
        _questions.onNext(getQuestions(of: self.category))
    }

    func answerQuestions(of question: Question) {}
}

// MARK: QuestionsListViewModel (Private)

private extension QuestionsListViewModel {
    func getQuestions(of cat: Category)->[Question] {
        return dataRepository.loadQuestions().filter{$0.category == Optional<Category>.some(cat)}
    }
}
