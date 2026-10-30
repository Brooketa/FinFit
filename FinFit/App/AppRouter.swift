import Foundation
import Observation
import HealthCheck

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case continueSession(sessionID: UUID)
        case questionnaire(sessionID: UUID)
        case result(HealthCheckResult)

    }

    var path: [Destination] = []

}

private extension AppRouter.Destination {

    var isQuestionnaire: Bool {
        guard case .questionnaire = self else { return false }

        return true
    }

}

// MARK: HealthCheckRoutingProtocol

extension AppRouter: HealthCheckRoutingProtocol {

    func navigateToIntro() {
        path.removeAll()
    }

    func navigateToContinueSession(sessionID: UUID) {
        path.append(.continueSession(sessionID: sessionID))
    }

    func navigateToQuestionnaire(sessionID: UUID) {
        path.append(.questionnaire(sessionID: sessionID))
    }

    func navigateBackToQuestionnaire() {
        guard let questionnaireIndex = path.lastIndex(where: \.isQuestionnaire) else { return }

        path.removeLast(path.count - questionnaireIndex - 1)
    }

    func navigateToResult(_ result: HealthCheckResult) {
        path.append(.result(result))
    }

}
