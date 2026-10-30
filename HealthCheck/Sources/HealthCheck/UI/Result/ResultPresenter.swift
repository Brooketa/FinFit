import Observation

@MainActor
@Observable
public final class ResultPresenter {

    let model: ResultView.Model

    init(score: Int) {
        model = ResultView.Model(for: score)
    }

    func onFinishTapped() {}

    func onRetakeTapped() {}

}
