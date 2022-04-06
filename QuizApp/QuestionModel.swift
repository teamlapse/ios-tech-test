//
//  Question.swift
//  QuizApp
//
//  Created by Alex Little on 05/04/2022.
//

import Foundation

public struct QuestionModel: Identifiable, Equatable, Codable {
    public let id: Int
    public let question: String
    public let answer: Bool
}
