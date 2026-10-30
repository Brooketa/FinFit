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

    private let questionnaireUseCase: any QuestionnaireUseCaseProtocol
    private let sessionStore: any SessionStoreProtocol
    private let router: any HealthCheckRoutingProtocol

    private var sessionID: UUID
    private var isSessionCompleted = false

    init(
        sessionID: UUID,
        questionnaireUseCase: any QuestionnaireUseCaseProtocol,
        sessionStore: any SessionStoreProtocol,
        router: any HealthCheckRoutingProtocol
    ) {
        self.sessionID = sessionID
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

    private var sessionIDToResume: UUID {
        isSessionCompleted ? UUID() : sessionID
    }

    func startOrResumeSession() async {
        await loadSession(with: sessionIDToResume)
    }

    func tryAgain() async {
        guard case .error = state else { return }

        await loadSession(with: sessionIDToResume)
    }

    func startNewSession() async {
        guard case .error = state else { return }

        await loadSession(with: UUID())
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

    func onBackTapped() {
        router.navigateToIntro()
    }

    func onNextTapped() async {
        guard
            !isSubmitting,
            case .loaded(let question) = state,
            let answer = answerSelection.answer(for: question)
        else { return }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let session = try await questionnaireUseCase.submitAnswer(
                sessionID: sessionID,
                questionID: question.id,
                answer: answer)
            sessionStore.save(sessionID: sessionID)
            handle(session: session)
        } catch {
            state = .error
        }
    }

    func onSessionUnavailableAction(_ action: SessionUnavailable.Action) {
        Task {
            switch action {
            case .tryAgain:
                await tryAgain()
            case .startNewSession:
                await startNewSession()
            }
        }
    }

    private func loadSession(with loadedSessionID: UUID) async {
        state = .loading

        do {
            let session = try await questionnaireUseCase.startOrResumeSession(id: loadedSessionID)
            if loadedSessionID != sessionID {
                sessionStore.removeSessionID()
                sessionID = loadedSessionID
                isSessionCompleted = false
            }
            handle(session: session)
        } catch {
            state = .error
        }
    }

    private func handle(session: SessionUseCaseModel) {
        switch session {
        case .inProgress(let question, let progress):
            state = .loaded(Question(from: question, progress: progress))
            answerSelection = AnswerSelection()
        case .completed(let result):
            isSessionCompleted = true
            sessionStore.removeSessionID()
            router.navigateToResult(HealthCheckResult(from: result))
        }
    }

}
