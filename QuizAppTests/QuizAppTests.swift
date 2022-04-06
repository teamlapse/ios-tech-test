//
//  QuizAppTests.swift
//  QuizAppTests
//
//  Created by Alex Little on 05/04/2022.
//

import XCTest
@testable import QuizApp
import ComposableArchitecture

extension AppEnvironment {
    static let failing = AppEnvironment(
        mainQueue: .failing,
        backgroundQueue: .failing,
        fetchQuestions: { .failing("fetchQuestions") }
    )
}

class QuizAppTests: XCTestCase {
    let testScheduler = DispatchQueue.test
    
    static var testQuestions: [QuestionModel] {
        [
            .init(id: 0, question: "How are you?", answer: true),
            .init(id: 1, question: "Hold old are you?", answer: true)
        ]
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDidBecomeActive() throws {
        var environment: AppEnvironment = .failing
        environment.fetchQuestions = {
            return .init(value: .setQuestions(QuizAppTests.testQuestions))
        }
        let state = QuestionScreenState()
        
        let store = TestStore(
            initialState: state,
            reducer: questionScreenReducer,
            environment: environment
        )
        
        store.send(.didBecomeActive)
        
        store.receive(.setQuestions(QuizAppTests.testQuestions)) {
            $0.questions = .init(uniqueElements: QuizAppTests.testQuestions)
            $0.hasLoadedQuestions = true
        }
    }

}
