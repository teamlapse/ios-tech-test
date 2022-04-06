//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import SwiftUI
import ComposableArchitecture
import Combine

@main
struct QuizAppApp: App {
    let store: Store<QuestionScreenState, QuestionScreenAction> = .init(
        initialState: .init(),
        reducer: questionScreenReducer,
        environment: AppEnvironment(
            mainQueue: .main,
            backgroundQueue: DispatchQueue.global().eraseToAnyScheduler(),
            fetchQuestions: {
                guard let filePath = Bundle.main.path(forResource: "true-false-questions", ofType: "json") else {
                    return .none
                }
                return Just(filePath)
                    .compactMap { filePath -> [QuestionModel]? in
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
                            let questions = try JSONDecoder().decode([QuestionModel].self, from: data)
                            return questions
                        } catch {
                            print(error)
                            return nil
                        }
                    }
                    .map(QuestionScreenAction.setQuestions)
                    .eraseToEffect()
            }
        )
    )
    
    var body: some Scene {
        WindowGroup {
            QuestionScreenView(
                store: store
            )
        }
    }
}
