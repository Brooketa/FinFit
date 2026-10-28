import FactoryKit
import Home

extension Container {

    @MainActor
    func registerRouting(_ router: AppRouter) {
        homeRouting.register { router }
    }

}
