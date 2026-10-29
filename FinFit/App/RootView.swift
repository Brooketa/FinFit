import SwiftUI
import HealthCheck

struct RootView: View {

    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            IntroView()
        }
    }

}
