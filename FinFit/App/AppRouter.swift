import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case questionnaire

    }

    var path: [Destination] = []

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {

    func navigateToQuestionnaire() {
        path.append(.questionnaire)
    }

}
