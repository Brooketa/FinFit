import Foundation
@testable import HealthCheck

@MainActor
final class HealthCheckRouterSpy: HealthCheckRoutingProtocol {

    enum Call: Equatable {

        case intro
        case continueSession(sessionID: UUID)
        case questionnaire(sessionID: UUID)
        case backToQuestionnaire
        case result(HealthCheckResult)

    }

    private(set) var calls: [Call] = []

    func navigateToIntro() {
        calls.append(.intro)
    }

    func navigateToContinueSession(sessionID: UUID) {
        calls.append(.continueSession(sessionID: sessionID))
    }

    func navigateToQuestionnaire(sessionID: UUID) {
        calls.append(.questionnaire(sessionID: sessionID))
    }

    func navigateBackToQuestionnaire() {
        calls.append(.backToQuestionnaire)
    }

    func navigateToResult(_ result: HealthCheckResult) {
        calls.append(.result(result))
    }

}

extension HealthCheckRouterSpy.Call {

    var questionnaireSessionID: UUID? {
        guard case .questionnaire(let sessionID) = self else { return nil }

        return sessionID
    }

}
