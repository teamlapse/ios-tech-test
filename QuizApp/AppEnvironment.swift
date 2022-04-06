//
//  AppEnvironment.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import Foundation
import ComposableArchitecture

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue>
    var backgroundQueue: AnySchedulerOf<DispatchQueue>
    var fetchQuestions: () -> Effect<QuestionScreenAction, Never>
}
