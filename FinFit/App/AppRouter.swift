import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case result

    }

    var path: [Destination] = []

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {

    func navigateToResult() {
        path.append(.result)
    }

}
