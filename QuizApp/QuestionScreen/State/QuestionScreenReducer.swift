import ComposableArchitecture
import Combine

let questionScreenReducer = Reducer<QuestionScreenState, QuestionScreenAction, AppEnvironment> { state, action, environment in
    switch action {
    case .didBecomeActive:
        // LOAD QUESTIONS FROM API
        guard !state.hasLoadedQuestions,
              let filePath = Bundle.main.path(forResource: "true-false-questions", ofType: "json") else {
                  break
              }
        
        return Just(filePath)
            .subscribe(on: environment.backgroundQueue)
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
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .setQuestions(let models):
        state.hasLoadedQuestions = true
        state.questions = .init(uniqueElements: models)
        
    case .didAnswer(let answer):
        if let question = state.currentQuestion,
           answer == question.answer {
            state.correctQuestions.append(question)
            state.questions.removeFirst()
            state.score += 1
        } else {
            // SHOW FAILURE SCREEN WITH RESULTS
            state.failedQuestion = state.currentQuestion
            if state.score == 3 {
                state.score = 2
            }
        }
        
    case .replay:
        state.score = 0
        for question in state.correctQuestions {
            state.questions.insert(question, at: 0)
        }
        state.correctQuestions.removeAll()
        state.failedQuestion = nil
        
    case .back:
        if let last = state.correctQuestions.last {
            state.correctQuestions.remove(id: last.id)
            state.questions.insert(last, at: 0)
        }
        if let last = state.correctQuestions.last {
            state.correctQuestions.remove(id: last.id)
            state.questions.insert(last, at: 0)
        }
        state.score -= 1
    }
    return .none
}
