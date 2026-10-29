import Observation

@MainActor
@Observable
public final class QuestionnairePresenter {

    let model = QuestionnaireView.Model(
        progress: 0.2,
        title: "What are you investing for?",
        description: "Select up to three goals.")

    func onNextTapped() {}

}
