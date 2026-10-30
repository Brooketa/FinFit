import Observation

@MainActor
@Observable
public final class ResultPresenter {

    let summary: ResultSummary

    private let router: any HealthCheckRoutingProtocol

    init(result: HealthCheckResult, router: any HealthCheckRoutingProtocol) {
        summary = ResultSummary(from: result)
        self.router = router
    }

    func onFinishTapped() {
        router.navigateToIntro()
    }

    func onRetakeTapped() {
        router.navigateBackToQuestionnaire()
    }

}
