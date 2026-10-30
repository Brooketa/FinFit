import Foundation
import Observation
import SwiftUI
import CoreUI

@MainActor
@Observable
public final class QuestionnairePresenter {

    private(set) var state = ViewState<Question>.idle
    private(set) var answerSelection = AnswerSelection()
    private(set) var isSubmitting = false

    private let sessionID: UUID
    private let questionnaireUseCase: any QuestionnaireUseCaseProtocol
    private let sessionStore: any SessionStoreProtocol
    private let router: any HealthCheckRoutingProtocol

    init(
        questionnaireUseCase: any QuestionnaireUseCaseProtocol,
        sessionStore: any SessionStoreProtocol,
        router: any HealthCheckRoutingProtocol
    ) {
        self.sessionID = sessionStore.sessionID ?? UUID()
        self.questionnaireUseCase = questionnaireUseCase
        self.sessionStore = sessionStore
        self.router = router
    }

    var isNextEnabled: Bool {
        guard case .loaded(let question) = state else { return false }

        return answerSelection.isComplete(for: question)
    }

    var numberAnswerText: Binding<String> {
        Binding(
            get: { [weak self] in self?.answerSelection.numberText ?? "" },
            set: { [weak self] in self?.onNumberAnswerChanged(text: $0) })
    }

    var numberAnswerStatus: TextInput.Status {
        guard
            case .loaded(let question) = state,
            answerSelection.isNumberOutOfRange(for: question)
        else { return .normal }

        return .error(.questionnaireNumberOutOfRange)
    }

    func startOrResumeSession() async {
        state = .loading

        do {
            let session = try await questionnaireUseCase.startOrResumeSession(id: sessionID)
            sessionStore.save(sessionID: sessionID)
            handle(session: session)
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

    func onNextTapped() async {
        guard
            !isSubmitting,
            case .loaded(let question) = state,
            let answer = answerSelection.answer(for: question)
        else { return }

        isSubmitting = true
        defer { isSubmitting = false }

        let session = try? await questionnaireUseCase.submitAnswer(
            sessionID: sessionID,
            questionID: question.id,
            answer: answer)
        guard let session else { return }

        handle(session: session)
    }

    private func handle(session: SessionUseCaseModel) {
        switch session {
        case .inProgress(let question, let progress):
            state = .loaded(Question(from: question, progress: progress))
            answerSelection = AnswerSelection()
        case .completed(let result):
            sessionStore.removeSessionID()
            router.navigateToResult(HealthCheckResult(from: result))
        }
    }

}
