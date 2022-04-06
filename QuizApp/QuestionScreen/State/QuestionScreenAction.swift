import Foundation

enum QuestionScreenAction: Equatable {
    case didBecomeActive
    
    case setQuestions([QuestionModel])
    
    case didAnswer(Bool)
    
    case replay
    case back
}
