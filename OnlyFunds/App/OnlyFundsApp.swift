import SwiftUI
import FactoryKit

@main
struct OnlyFundsApp: App {

    private let router = AppRouter()

    init() {
        Container.shared.registerRouting(router)
    }

    var body: some Scene {
        WindowGroup {
            RootView(router: router)
        }
    }

}
