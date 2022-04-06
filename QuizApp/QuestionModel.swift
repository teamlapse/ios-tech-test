//
//  Question.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import Foundation

struct QuestionModel: Identifiable, Equatable, Codable {
    let id: Int
    let question: String
    let answer: Bool
}
