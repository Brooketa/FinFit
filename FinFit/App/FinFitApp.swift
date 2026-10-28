import SwiftUI
import FactoryKit

@main
struct FinFitApp: App {

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
