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
    
    func testSetQuestions() throws {
        let environment: AppEnvironment = .failing
        let state = QuestionScreenState()
        
        let store = TestStore(
            initialState: state,
            reducer: questionScreenReducer,
            environment: environment
        )
        
        store.send(.setQuestions(QuizAppTests.testQuestions)) {
            $0.questions = .init(uniqueElements: QuizAppTests.testQuestions)
            $0.hasLoadedQuestions = true
        }
    }

    func testDidAnswerCorrect() throws {
        let environment: AppEnvironment = .failing
        var state = QuestionScreenState()
        state.hasLoadedQuestions = true
        state.questions = .init(uniqueElements: QuizAppTests.testQuestions)
        
        let store = TestStore(
            initialState: state,
            reducer: questionScreenReducer,
            environment: environment
        )
        
        store.send(.didAnswer(true)) {
            $0.correctQuestions.append(QuizAppTests.testQuestions.first!)
            $0.questions.remove(id: QuizAppTests.testQuestions.first!.id)
        }
    }
    
    func testDidAnswerIncorrect() throws {
        let environment: AppEnvironment = .failing
        var state = QuestionScreenState()
        state.hasLoadedQuestions = true
        state.questions = .init(uniqueElements: QuizAppTests.testQuestions)
        
        let store = TestStore(
            initialState: state,
            reducer: questionScreenReducer,
            environment: environment
        )
        
        store.send(.didAnswer(false)) {
            $0.failedQuestion = $0.currentQuestion
        }
    }
    
    func testReplay() throws {
        let environment: AppEnvironment = .failing
        var state = QuestionScreenState()
        state.hasLoadedQuestions = true
        state.questions = .init(uniqueElements: [QuizAppTests.testQuestions.last!])
        state.correctQuestions = .init(uniqueElements: [QuizAppTests.testQuestions.first!])
        
        let store = TestStore(
            initialState: state,
            reducer: questionScreenReducer,
            environment: environment
        )
        
        store.send(.replay) {
            $0.questions = .init(uniqueElements: QuizAppTests.testQuestions)
            $0.correctQuestions = .init(uniqueElements: [])
            $0.failedQuestion = nil
        }
    }
}
