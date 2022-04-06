import Foundation
import ComposableArchitecture

public struct QuestionScreenState: Equatable {
    public var hasLoadedQuestions: Bool = false
    public var questions: IdentifiedArrayOf<QuestionModel> = []
    public var correctQuestions: IdentifiedArrayOf<QuestionModel> = []
    public var failedQuestion: QuestionModel?
    
    public var currentQuestion: QuestionModel? {
        return questions.first
    }
    
    public var totalCount: Int {
        return questions.count + correctQuestions.count
    }
    
    public var screenState: State {
        if failedQuestion != nil {
            return .failed(score: correctQuestions.count)
        } else if let currentQuestion = currentQuestion {
            return .question(currentQuestion)
        } else {
            return .success
        }
    }
    
    public enum State: Equatable {
        case question(QuestionModel)
        case failed(score: Int)
        case success
    }
}
