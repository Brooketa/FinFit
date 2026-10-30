import Foundation
import Observation

@MainActor
@Observable
public final class ContinueSessionPresenter {

    private let sessionID: UUID
    private let sessionStore: any SessionStoreProtocol
    private let router: any HealthCheckRoutingProtocol

    init(sessionID: UUID, sessionStore: any SessionStoreProtocol, router: any HealthCheckRoutingProtocol) {
        self.sessionID = sessionID
        self.sessionStore = sessionStore
        self.router = router
    }

    func onContinueTapped() {
        router.navigateToQuestionnaire(sessionID: sessionID)
    }

    func onStartOverTapped() {
        sessionStore.removeSessionID()
        router.navigateToQuestionnaire(sessionID: UUID())
    }

}
