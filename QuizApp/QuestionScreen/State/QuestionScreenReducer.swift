import ComposableArchitecture
import Combine

let questionScreenReducer = Reducer<QuestionScreenState, QuestionScreenAction, AppEnvironment> { state, action, environment in
    switch action {
    case .didBecomeActive:
        // LOAD QUESTIONS FROM API
        guard !state.hasLoadedQuestions else {
            break
        }
        
        return environment.fetchQuestions()
    case .setQuestions(let models):
        state.hasLoadedQuestions = true
        state.questions = .init(uniqueElements: models)
        
    case .didAnswer(let answer):
        if let question = state.currentQuestion,
           answer == question.answer {
            state.correctQuestions.append(question)
            state.questions.removeFirst()
        } else {
            // SHOW FAILURE SCREEN WITH RESULTS
            state.failedQuestion = state.currentQuestion
        }
        
    case .replay:
        for question in state.correctQuestions {
            state.questions.insert(question, at: 0)
        }
        state.correctQuestions.removeAll()
        state.failedQuestion = nil
    }
    return .none
}
