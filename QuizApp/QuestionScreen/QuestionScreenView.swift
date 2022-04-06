import ComposableArchitecture
import SwiftUI

struct QuizButton: View {
    let text: String

    var body: some View {
        ZStack {
            Color.white
            Text(text)
                .font(.custom("Plakat", size: 32))
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .frame(width: 160, height: 50)
        .border(Color(red: 39/255, green: 82/255, blue: 255/255), width: 5)
        .contentShape(Rectangle())
    }
}

struct QuestionScreenView: View {
    @Environment(\.scenePhase) var scenePhase

    let store: Store<QuestionScreenState, QuestionScreenAction>
    
    init(store: Store<QuestionScreenState, QuestionScreenAction>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                background
                VStack {
                    Image("QuizpediaLogo", bundle: .main)
                    Spacer()
                }
                VStack {
                    Spacer()
                    switch viewStore.screenState {
                    case .question(let question):
                        VStack(spacing: 22) {
                            Text("Score: \(viewStore.correctQuestions.count)/\(viewStore.totalCount)")
                                .font(.custom("Sneak-Medium", size: 20))
                            Text(question.question)
                                .font(.custom("Plakat", size: 30))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        HStack {
                            QuizButton(text: "TRUE")
                                .onTapGesture {
                                    viewStore.send(.didAnswer(true))
                                }
    
                            QuizButton(text: "FALSE")
                                .onTapGesture {
                                    viewStore.send(.didAnswer(false))
                                }
                        }
                    case .success:
                        Text("YOU'RE A QUIZZARD")
                            .font(.custom("Plakat", size: 60))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                        QuizButton(text: "10/10")
                        QuizButton(text: "REPLAY")
                            .onTapGesture {
                                viewStore.send(.replay)
                            }
                    case .failed(let score):
                        Text("GAME OVER")
                            .font(.custom("Plakat", size: 60))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                        QuizButton(text: "Score \(score)")
                        QuizButton(text: "REPLAY")
                            .onTapGesture {
                                viewStore.send(.replay)
                            }
                    }
                }
                
            }
            .background(background)
            .onChange(of: scenePhase) { phase in
                guard phase == .active else { return }
                if viewStore.hasLoadedQuestions {
                    viewStore.send(.replay)
                } else {
                    viewStore.send(.didBecomeActive)
                }
            }
        }
        
    }
    
    var background: some View {
        LinearGradient(
            colors: [
                Color(.displayP3, red: 235/255, green: 220/255, blue: 252/255, opacity: 1),
                Color(.displayP3, red: 204/255, green: 250/255, blue: 254/255, opacity: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
            .ignoresSafeArea(.all, edges: .all)
    }
}

struct QuestionScreenView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionScreenView(
            store: Store(
                initialState: .init(),
                reducer: questionScreenReducer,
                environment: AppEnvironment(
                    mainQueue: .immediate,
                    backgroundQueue: .immediate
                )
            )
        )
    }
}
