import Observation

@MainActor
@Observable
public final class ResultPresenter {

    let model = ResultView.Model(
        progress: 0.78,
        title: .resultTitle,
        subtitle: .resultSubtitle)

    func onFinishTapped() {}

    func onRetakeTapped() {}

}
