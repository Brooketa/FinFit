import SwiftUI
import Home

struct RootView: View {

    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView()
                .navigationDestination(for: AppRouter.Destination.self, destination: destinationView)
        }
    }

}

private extension RootView {

    func destinationView(for destination: AppRouter.Destination) -> some View {
        switch destination {
        case .about:
            AboutView()
        }
    }

}
