import Foundation
import ComposableArchitecture

struct QuestionScreenState: Equatable {
    var hasLoadedQuestions: Bool = false
    var questions: IdentifiedArrayOf<QuestionModel> = []
    var correctQuestions: IdentifiedArrayOf<QuestionModel> = []
    var failedQuestion: QuestionModel?
    
    var currentQuestion: QuestionModel? {
        return questions.first
    }
    
    var totalCount: Int {
        return questions.count + correctQuestions.count
    }
    
    var screenState: State {
        if failedQuestion != nil {
            return .failed(score: correctQuestions.count)
        } else if let currentQuestion = currentQuestion {
            return .question(currentQuestion)
        } else {
            return .success
        }
    }
    
    enum State: Equatable {
        case question(QuestionModel)
        case failed(score: Int)
        case success
    }
}
