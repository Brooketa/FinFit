import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case questionnaire
        case result(score: Int)

    }

    var path: [Destination] = []

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {

    func navigateToQuestionnaire() {
        path.append(.questionnaire)
    }

    func navigateToResult(score: Int) {
        path = [.result(score: score)]
    }

}
