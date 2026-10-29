import Observation

@MainActor
@Observable
public final class IntroPresenter {

    private let router: any HealthCheckRoutingProtocol

    init(router: any HealthCheckRoutingProtocol) {
        self.router = router
    }

    func onStartTapped() {
        router.navigateToResult()
    }

}
