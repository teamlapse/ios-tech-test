//
//  AppEnvironment.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import Foundation
import ComposableArchitecture

struct AppEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let backgroundQueue: AnySchedulerOf<DispatchQueue>
}
