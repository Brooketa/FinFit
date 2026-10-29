import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {}

    var path: [Destination] = []

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {}
