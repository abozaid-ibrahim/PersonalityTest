//
//  PersonalityTestTests.swift
//  PersonalityTestTests
//
//  Created by abuzeid on 11/10/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import Nimble
@testable import PersonalityTest
import Quick
import RxNimble
import RxOptional
import RxSwift
import RxTest
import XCTest
class QuestionsViewModelTests: QuickSpec {
    override func spec() {
        describe("questions list") {
            var schedular: TestScheduler!
            var questionsObserver: TestableObserver<[Question]>!
            var disposeBag = DisposeBag()
            beforeEach {
                schedular = TestScheduler(initialClock: 0)
                questionsObserver = schedular.createObserver([Question].self)
                disposeBag = DisposeBag()
            }

            context("questions view") {
                var viewModel: QuestionsViewModel!
                beforeEach {
                    let cat = QCategory.lifestyle
                    viewModel = QuestionsListViewModel(repo: MockedQuestionsRepo(), category: cat)
                }
                it("show only the life style questions") {
                    viewModel.questions.bind(to: questionsObserver).disposed(by: disposeBag)
                    viewModel.loadData()
                    schedular.start()
                    expect(questionsObserver.events)
                        .to(equal(
                            [Recorded.next(0, [MockedQuestionsRepo.q0, MockedQuestionsRepo.q1, MockedQuestionsRepo.q2])]
                        ))
                }
            }
            context("select answers") {
                var viewModel: QuestionsViewModel!
                var selectAnswer: TestableObservable<IndexPath>!
                beforeEach {
                    let cat = QCategory.lifestyle
                    viewModel = QuestionsListViewModel(repo: MockedQuestionsRepo(), category: cat)
                }
                it("select first answer") {
                    selectAnswer = schedular.createColdObservable([Recorded.next(0, IndexPath(row: 0, section: 0))])
                    viewModel.questions.bind(to: questionsObserver).disposed(by: disposeBag)
                    selectAnswer.subscribe(onNext: { value in
                        viewModel.answerQuestions(answered: true, for: value)
                    }).disposed(by: disposeBag)
                    viewModel.loadData()
                    schedular.start()
                    expect(viewModel.questionIsAnswered(index: IndexPath(row: 0, section: 0)))
                        .to(equal(true))
                    expect(viewModel.questionIsAnswered(index: IndexPath(row: 1, section: 1)))
                        .to(equal(false))
                }
                it("select all answer") {
                    selectAnswer = schedular.createColdObservable([
                        Recorded.next(0, IndexPath(row: 0, section: 0)),
                        Recorded.next(0, IndexPath(row: 0, section: 1)),
                        Recorded.next(0, IndexPath(row: 0, section: 2)),
                    ])
                    viewModel.questions.bind(to: questionsObserver).disposed(by: disposeBag)
                    selectAnswer.subscribe(onNext: { value in
                        viewModel.answerQuestions(answered: true, for: value)
                    }).disposed(by: disposeBag)
                    viewModel.loadData()
                    schedular.start()
                    expect(viewModel.allIsAnswered)
                        .to(equal(true))
                }
            }
        }
    }
}

class MockedQuestionsRepo: QuestionsRepository {
    static let q0 = Question(question: "x", category: .lifestyle, answered: false, answers: nil)
    static let q1 = Question(question: "x", category: .lifestyle, answered: false, answers: nil)
    static let q2 = Question(question: "x", category: .lifestyle, answered: false, answers: nil)
    func loadCategories() -> [QCategory] {
        return QCategory.allCases
    }

    func loadQuestions() -> [Question] {
        let answer = QuestionOptions(type: .singleChoice, options: ["test"], condition: nil)
        let q3 = Question(question: "x", category: .hardFact, answered: false, answers: answer)
        let q4 = Question(question: "x", category: .introversion, answered: false, answers: answer)
        let q5 = Question(question: "x", category: .hardFact, answered: false, answers: answer)
        let q6 = Question(question: "x", category: .passion, answered: false, answers: answer)
        return [MockedQuestionsRepo.q1, MockedQuestionsRepo.q0, q3, q4, MockedQuestionsRepo.q2, q5, q6]
    }
}
