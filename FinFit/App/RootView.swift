import SwiftUI
import HealthCheck

struct RootView: View {

    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            IntroView()
                .navigationDestination(for: AppRouter.Destination.self) { destination in
                    switch destination {
                    case .continueSession(let sessionID):
                        ContinueSessionView(sessionID: sessionID)
                    case .questionnaire(let sessionID):
                        QuestionnaireView(sessionID: sessionID)
                    case .result(let result):
                        ResultView(result: result)
                    }
                }
        }
    }

}
