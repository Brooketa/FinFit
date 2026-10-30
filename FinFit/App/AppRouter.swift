import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case questionnaire
        case result(HealthCheckResult)

    }

    var path: [Destination] = []

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {

    func navigateToQuestionnaire() {
        path.append(.questionnaire)
    }

    func navigateToResult(_ result: HealthCheckResult) {
        path.append(.result(result))
    }

}
