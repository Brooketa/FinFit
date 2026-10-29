import SwiftUI
import HealthCheck

struct RootView: View {

    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            IntroView()
                .navigationDestination(for: AppRouter.Destination.self) { destination in
                    switch destination {
                    case .questionnaire:
                        QuestionnaireView()
                    }
                }
        }
    }

}
