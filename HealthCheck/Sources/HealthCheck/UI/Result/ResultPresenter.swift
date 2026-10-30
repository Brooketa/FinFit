import Observation

@MainActor
@Observable
public final class ResultPresenter {

    let summary: ResultSummary

    init(result: HealthCheckResult) {
        summary = ResultSummary(from: result)
    }

    func onFinishTapped() {}

    func onRetakeTapped() {}

}
