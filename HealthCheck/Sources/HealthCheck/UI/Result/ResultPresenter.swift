import Observation

@MainActor
@Observable
public final class ResultPresenter {

    let model = ResultView.Model(for: 78)

    func onFinishTapped() {}

    func onRetakeTapped() {}

}
