//
//  MemoryLeaks.swift
//  PersonalityTestTests
//
//  Created by abuzeid on 11/18/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import XCTest

import Nimble
@testable import PersonalityTest
import Quick
import RxNimble
import RxOptional
import RxSwift
import SpecLeaks
import RxTest
import XCTest
class QuestionsMemoryLeaksTests: QuickSpec {
    override func spec() {
        describe("MyViewController") {
            describe("init") {
                it("must not leak") {
                     let vc = LeakTest {
                        Destination.questions(.lifestyle).getQuestionsView(for: .lifestyle)
                    }
                    expect(vc).toNot(leak())
                }
            }
        }
    }
}
