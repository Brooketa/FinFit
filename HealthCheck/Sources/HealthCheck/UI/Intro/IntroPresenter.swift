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
        router.navigateToQuestionnaire(sessionID: sessionStore.sessionID ?? UUID())
    }

}
