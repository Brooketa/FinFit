import Foundation
import Testing
@testable import HealthCheck

@MainActor
@Suite("QuestionnairePresenter")
final class QuestionnairePresenterTests {

    private let sessionID = UUID()
    private let questionnaireUseCaseMock = QuestionnaireUseCaseMock()
    private let sessionStoreMock = SessionStoreMock()
    private let routerSpy = HealthCheckRouterSpy()
    private let questionnairePresenter: QuestionnairePresenter

    init() {
        questionnairePresenter = QuestionnairePresenter(
            sessionID: sessionID,
            questionnaireUseCase: questionnaireUseCaseMock,
            sessionStore: sessionStoreMock,
            router: routerSpy)
    }

    @Test("Loading starts the given session and shows its current question")
    func loadingShowsQuestion() async {
        questionnaireUseCaseMock.startResult = .success(.fixture(
            question: .fixture(id: "income_stability"),
            progress: .fixture(current: 2, total: 5)))

        await questionnairePresenter.startOrResumeSession()

        #expect(questionnaireUseCaseMock.startedSessionIDs == [sessionID])
        #expect(questionnairePresenter.state.loadedContent?.id == "income_stability")
        #expect(questionnairePresenter.state.loadedContent?.progress == 0.4)
    }

    @Test("A failed load moves to the error state and saves nothing")
    func failedLoadShowsError() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())

        await questionnairePresenter.startOrResumeSession()

        #expect(questionnairePresenter.state.isError)
        #expect(sessionStoreMock.savedSessionIDs.isEmpty)
    }

    @Test("Loading doesn't save the session")
    func loadingDoesNotSave() async {
        await questionnairePresenter.startOrResumeSession()

        #expect(sessionStoreMock.savedSessionIDs.isEmpty)
    }

    @Test("Loading a session that's already complete removes it and navigates to the result")
    func loadingCompletedSessionShowsResult() async {
        questionnaireUseCaseMock.startResult = .success(.completedFixture(result: .fixture(score: 64, category: .fair)))

        await questionnairePresenter.startOrResumeSession()

        #expect(sessionStoreMock.removeCount == 1)
        #expect(routerSpy.calls == [.result(HealthCheckResult(score: 64, category: .fair))])
    }

    @Test("The question id follows the loaded question and is absent otherwise")
    func questionIDFollowsLoadedQuestion() async {
        #expect(questionnairePresenter.questionID == nil)

        questionnaireUseCaseMock.startResult = .success(.fixture(question: .fixture(id: "income_stability")))
        await questionnairePresenter.startOrResumeSession()
        #expect(questionnairePresenter.questionID == "income_stability")

        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .failure(TestError.fixture())
        await questionnairePresenter.onNextTapped()
        #expect(questionnairePresenter.questionID == nil)
    }

    @Test("Next is enabled only once the loaded question has a complete answer")
    func nextIsEnabledWhenAnswerIsComplete() async {
        #expect(!questionnairePresenter.isNextEnabled)

        await questionnairePresenter.startOrResumeSession()
        #expect(!questionnairePresenter.isNextEnabled)

        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        #expect(questionnairePresenter.isNextEnabled)
    }

    @Test("Tapping Next submits the answer, saves the session and shows the next question with nothing selected")
    func nextSubmitsAndShowsNextQuestion() async throws {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .success(.fixture(question: .fixture(id: "monthly_income")))

        await questionnairePresenter.onNextTapped()

        let submission = try #require(questionnaireUseCaseMock.submissions.first)
        #expect(submission.sessionID == sessionID)
        #expect(submission.questionID == "income_stability")
        #expect(submission.answer == .option("option_1"))
        #expect(sessionStoreMock.savedSessionIDs == [sessionID])
        #expect(questionnairePresenter.state.loadedContent?.id == "monthly_income")
        #expect(questionnairePresenter.answerSelection.selectedAnswerID == nil)
        #expect(!questionnairePresenter.isSubmitting)
    }

    @Test("Tapping Next without a complete answer submits nothing")
    func nextWithoutAnswerDoesNothing() async {
        await questionnairePresenter.startOrResumeSession()

        await questionnairePresenter.onNextTapped()

        #expect(questionnaireUseCaseMock.submissions.isEmpty)
    }

    @Test("A failed submission shows the error state and saves nothing")
    func failedSubmissionShowsError() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .failure(TestError.fixture())

        await questionnairePresenter.onNextTapped()

        #expect(questionnairePresenter.state.isError)
        #expect(sessionStoreMock.savedSessionIDs.isEmpty)
        #expect(!questionnairePresenter.isSubmitting)
    }

    @Test("Try again reloads the same session and shows its current question")
    func tryAgainShowsCurrentQuestion() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()
        questionnaireUseCaseMock.startResult = .success(.fixture(question: .fixture(id: "monthly_income")))

        await questionnairePresenter.tryAgain()

        #expect(questionnaireUseCaseMock.startedSessionIDs == [sessionID, sessionID])
        #expect(questionnairePresenter.state.loadedContent?.id == "monthly_income")
    }

    @Test("Try again on a session that has completed opens its result")
    func tryAgainOpensResultOfCompletedSession() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .failure(TestError.fixture())
        await questionnairePresenter.onNextTapped()
        questionnaireUseCaseMock.startResult = .success(.completedFixture(result: .fixture(score: 64, category: .fair)))

        await questionnairePresenter.tryAgain()

        #expect(questionnaireUseCaseMock.startedSessionIDs.last == sessionID)
        #expect(routerSpy.calls == [.result(HealthCheckResult(score: 64, category: .fair))])
    }

    @Test("Try again after a failed retake starts a new session instead of reopening the old result")
    func tryAgainAfterFailedRetakeStartsNewSession() async throws {
        questionnaireUseCaseMock.startResult = .success(.completedFixture())
        await questionnairePresenter.startOrResumeSession()
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()
        questionnaireUseCaseMock.startResult = .success(.fixture())

        await questionnairePresenter.tryAgain()

        let retriedSessionID = try #require(questionnaireUseCaseMock.startedSessionIDs.last)
        #expect(retriedSessionID != sessionID)
        #expect(questionnairePresenter.state.loadedContent != nil)
        #expect(routerSpy.calls.count == 1)
    }

    @Test("Try again that fails again keeps the error state")
    func failedTryAgainKeepsError() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()

        await questionnairePresenter.tryAgain()

        #expect(questionnaireUseCaseMock.startedSessionIDs.count == 2)
        #expect(questionnairePresenter.state.isError)
    }

    @Test("Start a new session loads a new one with a new id, then removes the saved session")
    func startNewSessionUsesNewID() async throws {
        sessionStoreMock.save(sessionID: sessionID)
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()
        questionnaireUseCaseMock.startResult = .success(.fixture())

        await questionnairePresenter.startNewSession()

        #expect(sessionStoreMock.removeCount == 1)
        #expect(sessionStoreMock.sessionID == nil)
        let newSessionID = try #require(questionnaireUseCaseMock.startedSessionIDs.last)
        #expect(newSessionID != sessionID)
        #expect(questionnairePresenter.state.loadedContent != nil)
        #expect(!questionnairePresenter.state.isError)
    }

    @Test("Start a new session that fails keeps the saved session and the current session id")
    func failedStartNewSessionKeepsSavedSession() async throws {
        sessionStoreMock.save(sessionID: sessionID)
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()

        await questionnairePresenter.startNewSession()

        #expect(questionnairePresenter.state.isError)
        #expect(sessionStoreMock.removeCount == 0)
        #expect(sessionStoreMock.sessionID == sessionID)

        questionnaireUseCaseMock.startResult = .success(.fixture())
        await questionnairePresenter.tryAgain()

        #expect(questionnaireUseCaseMock.startedSessionIDs.last == sessionID)
        #expect(questionnairePresenter.state.loadedContent != nil)
    }

    @Test("While Try again runs, the screen shows loading and another tap is ignored")
    func tryAgainInFlightShowsLoadingAndIgnoresTaps() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()
        questionnaireUseCaseMock.startResult = .success(.fixture())
        questionnaireUseCaseMock.holdStarts()

        let retry = Task {
            await questionnairePresenter.tryAgain()
        }
        while questionnaireUseCaseMock.heldStartCount == 0 {
            await Task.yield()
        }
        #expect(questionnairePresenter.state.isLoading)

        await questionnairePresenter.startNewSession()
        questionnaireUseCaseMock.releaseStarts()
        await retry.value

        #expect(questionnaireUseCaseMock.startedSessionIDs.count == 2)
        #expect(questionnairePresenter.state.loadedContent != nil)
    }

    @Test("Retrying keeps the error state on screen until the session loads")
    func retryKeepsErrorUntilLoaded() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()

        await questionnairePresenter.tryAgain()

        #expect(questionnairePresenter.state.isError)
    }

    @Test("Tapping Next while a submission is in flight doesn't submit again")
    func nextDuringSubmissionIsIgnored() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.holdSubmissions()

        let firstSubmission = Task {
            await questionnairePresenter.onNextTapped()
        }
        while questionnaireUseCaseMock.heldSubmissionCount == 0 {
            await Task.yield()
        }
        #expect(questionnairePresenter.isSubmitting)

        let secondSubmission = Task {
            await questionnairePresenter.onNextTapped()
        }
        for _ in 0..<Constants.yieldCount {
            await Task.yield()
        }
        questionnaireUseCaseMock.releaseSubmissions()
        await firstSubmission.value
        await secondSubmission.value

        #expect(questionnaireUseCaseMock.submissions.count == 1)
    }

    @Test("A completed session removes the saved session and navigates to the result with its score and category")
    func completedSessionNavigatesToResult() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        let result = ResultUseCaseModel.fixture(score: 88, category: .excellent)
        questionnaireUseCaseMock.submitResult = .success(.completedFixture(result: result))

        await questionnairePresenter.onNextTapped()

        #expect(sessionStoreMock.removeCount == 1)
        #expect(sessionStoreMock.sessionID == nil)
        #expect(routerSpy.calls == [.result(HealthCheckResult(score: 88, category: .excellent))])
    }

    @Test("Loading again after the session completed starts a new session with a new id")
    func reloadAfterCompletionStartsNewSession() async throws {
        questionnaireUseCaseMock.startResult = .success(.completedFixture())
        await questionnairePresenter.startOrResumeSession()

        questionnaireUseCaseMock.startResult = .success(.fixture())
        await questionnairePresenter.startOrResumeSession()

        #expect(questionnaireUseCaseMock.startedSessionIDs.count == 2)
        let newSessionID = try #require(questionnaireUseCaseMock.startedSessionIDs.last)
        #expect(newSessionID != sessionID)
        #expect(questionnairePresenter.state.loadedContent != nil)
    }

    @Test("Tapping Back before any answer is accepted navigates to the intro without asking")
    func backBeforeAnswerNavigatesToIntro() async {
        await questionnairePresenter.startOrResumeSession()

        questionnairePresenter.onBackTapped()

        #expect(!questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(routerSpy.calls == [.intro])
    }

    @Test("Tapping Back on the error screen navigates to the intro without asking")
    func backOnErrorNavigatesToIntro() async {
        questionnaireUseCaseMock.startResult = .failure(TestError.fixture())
        await questionnairePresenter.startOrResumeSession()

        questionnairePresenter.onBackTapped()

        #expect(!questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(routerSpy.calls == [.intro])
    }

    @Test("Tapping Back after an answer is accepted asks for confirmation and stays")
    func backAfterAnswerAsksForConfirmation() async {
        await answerFirstQuestion()

        questionnairePresenter.onBackTapped()

        #expect(questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(routerSpy.calls.isEmpty)
    }

    @Test("Tapping Back on a resumed session past its first question asks for confirmation")
    func backOnResumedSessionAsksForConfirmation() async {
        questionnaireUseCaseMock.startResult = .success(.fixture(progress: .fixture(current: 3, total: 5)))
        await questionnairePresenter.startOrResumeSession()

        questionnairePresenter.onBackTapped()

        #expect(questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(routerSpy.calls.isEmpty)
    }

    @Test("Saving and leaving navigates to the intro and keeps the session saved")
    func saveAndLeaveKeepsSession() async {
        await answerFirstQuestion()
        questionnairePresenter.onBackTapped()

        questionnairePresenter.onLeaveConfirmationAction(.saveAndLeave)

        #expect(!questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(sessionStoreMock.removeCount == 0)
        #expect(sessionStoreMock.sessionID == sessionID)
        #expect(routerSpy.calls == [.intro])
    }

    @Test("Discarding and leaving removes the saved session and navigates to the intro")
    func discardAndLeaveRemovesSession() async {
        await answerFirstQuestion()
        questionnairePresenter.onBackTapped()

        questionnairePresenter.onLeaveConfirmationAction(.discardAndLeave)

        #expect(!questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(sessionStoreMock.removeCount == 1)
        #expect(sessionStoreMock.sessionID == nil)
        #expect(routerSpy.calls == [.intro])
    }

    @Test("Staying dismisses the confirmation and keeps the question and its selection")
    func stayKeepsQuestionAndSelection() async {
        await answerFirstQuestion()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_2")
        questionnairePresenter.onBackTapped()

        questionnairePresenter.onLeaveConfirmationAction(.stay)

        #expect(!questionnairePresenter.shouldPresentLeaveConfirmation)
        #expect(questionnairePresenter.state.loadedContent?.id == "monthly_income")
        #expect(questionnairePresenter.answerSelection.selectedAnswerID == "option_2")
        #expect(sessionStoreMock.removeCount == 0)
        #expect(routerSpy.calls.isEmpty)
    }

    @Test("The number input shows the out-of-range error only for an out-of-range number")
    func numberStatusShowsOutOfRange() async {
        questionnaireUseCaseMock.startResult = .success(.fixture(question: .fixture(type: .number(valueRange: 0...36))))
        await questionnairePresenter.startOrResumeSession()

        questionnairePresenter.onNumberAnswerChanged(text: "40")
        #expect(questionnairePresenter.numberAnswerStatus == .error(.questionnaireNumberOutOfRange))

        questionnairePresenter.onNumberAnswerChanged(text: "20")
        #expect(questionnairePresenter.numberAnswerStatus == .normal)

        questionnairePresenter.onNumberAnswerChanged(text: "twenty")
        #expect(questionnairePresenter.numberAnswerStatus == .normal)
    }

    private func answerFirstQuestion() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .success(.fixture(
            question: .fixture(id: "monthly_income"),
            progress: .fixture(current: 2, total: 5)))
        await questionnairePresenter.onNextTapped()
    }

}

private extension QuestionnairePresenterTests {

    enum Constants {

        static let yieldCount = 10

    }

}
