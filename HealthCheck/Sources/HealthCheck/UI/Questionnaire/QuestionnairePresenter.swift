import Foundation
import Observation
import CoreUI

@MainActor
@Observable
public final class QuestionnairePresenter {

    private(set) var state = ViewState<Question>.idle
    private(set) var answerSelection = AnswerSelection()

    private let sessionID = UUID()
    private let questionnaireUseCase: any QuestionnaireUseCaseProtocol

    init(questionnaireUseCase: any QuestionnaireUseCaseProtocol) {
        self.questionnaireUseCase = questionnaireUseCase
    }

    var isNextEnabled: Bool {
        guard case .loaded(let question) = state else { return false }

        return answerSelection.isComplete(for: question)
    }

    var isNumberAnswerOutOfRange: Bool {
        guard case .loaded(let question) = state else { return false }

        return answerSelection.isNumberOutOfRange(for: question)
    }

    func startOrResumeSession() async {
        state = .loading

        do {
            let session = try await questionnaireUseCase.startOrResumeSession(id: sessionID)
            guard case .inProgress(let question, let progress) = session else { return }

            state = .loaded(Question(from: question, progress: progress))
            answerSelection = AnswerSelection()
        } catch {
            state = .error
        }
    }

    func onSingleChoiceAnswerSelected(answerID: String) {
        answerSelection.select(answerID: answerID)
    }

    func onMultipleChoiceAnswerToggled(answerID: String) {
        guard case .loaded(let question) = state else { return }

        answerSelection.toggle(answerID: answerID, in: question)
    }

    func onNumberAnswerChanged(text: String) {
        answerSelection.enter(numberText: text)
    }

    func onNextTapped() {}

}
