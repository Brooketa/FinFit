import FactoryKit
import HealthCheck

extension Container {

    @MainActor
    func registerRouting(_ router: AppRouter) {
        healthCheckRouting.register { router }
    }

}
