import Foundation
import Observation

@MainActor
@Observable
public final class IntroPresenter {

    private let sessionStore: any SessionStoreProtocol
    private let router: any HealthCheckRoutingProtocol

    init(sessionStore: any SessionStoreProtocol, router: any HealthCheckRoutingProtocol) {
        self.sessionStore = sessionStore
        self.router = router
    }

    func onStartTapped() {
        guard let savedSessionID = sessionStore.sessionID else {
            router.navigateToQuestionnaire(sessionID: UUID())
            return
        }

        router.navigateToContinueSession(sessionID: savedSessionID)
    }

}
