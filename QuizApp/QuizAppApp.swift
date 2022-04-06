//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct QuizAppApp: App {
    let store: Store<QuestionScreenState, QuestionScreenAction> = .init(
        initialState: .init(),
        reducer: questionScreenReducer,
        environment: AppEnvironment(
            mainQueue: .main,
            backgroundQueue: DispatchQueue.global().eraseToAnyScheduler()
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
