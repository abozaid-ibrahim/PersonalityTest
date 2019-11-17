//
//  QuestionsTableViewModel.swift
//  PersonalityTest
//
//  Created by abuzeid on 11/17/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Foundation
import RxSwift

final class QuestionsTableViewModel {
    // MARK: private state

    private let disposeBag = DisposeBag()
    private let dataRepository: QuestionsRepository
    private let _questions = BehaviorSubject<[QuestionSectionModel]>(value: [])
    private let _showProgress = PublishSubject<Bool>()
    private let _error = PublishSubject<Error>()
    private(set) var category: QCategory
    private var questionsList: [QuestionSectionModel] {
        do {
            return try _questions.value()
        } catch {
            log(.error, error)
            return []
        }
    }

    lazy var changesCommand = TableViewEditingCommand()

    // MARK: Observers

    var showProgress: Observable<Bool> {
        return _showProgress.asObservable()
    }

    var questions: Observable<[QuestionSectionModel]> {
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

    func loadData() {
        let questionsList = dataRepository.loadQuestions()
            .filter { $0.category == Optional<QCategory>.some(category) }

        var sections: [QuestionSectionModel] = []
        for index in 0..<questionsList.count {
            let question = questionsList[index]
            var cond: RangeAnswerModel?
            if let req = question.answers?.condition?.predicate?.exactEquals?.last,
                let optionIndex = question.answers?.options?.firstIndex(of: req) {
                cond = question.answers?.condition?.ifPositive.map { RangeAnswerModel(sectionId: index, answerId: optionIndex, title: $0.question) }
            }

            if let options = question.answers?.options?.compactMap({ SelectableAnswerModel(sectionId: index, option: $0, conditional: cond) }) {
                let section = QuestionSectionModel(question: question.question, items: options)
                sections.append(section)
            }
        }

        _questions.onNext(sections)
    }

    func questionIsAnswered(index: IndexPath) -> Bool {
        return questionsList[index.section].answered
    }

    func answerQuestions(answered: Bool, for index: IndexPath) {
//        questionsList[index.section].setAnswered(answered)
    }

    func submitAll() {
        ///todo
    }

    func itemSelected(index: IndexPath) {
        let newValue = changesCommand.itemDeSelected(questions: questionsList, index: index)
        _questions.onNext(newValue)
    }

    func itemDeSelected(index: IndexPath) {
        let newValue = changesCommand.itemDeSelected(questions: questionsList, index: index)
        _questions.onNext(newValue)
    }
}
