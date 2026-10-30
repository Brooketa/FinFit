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

    @Test("A failed submission keeps the question and the selection, and saves nothing")
    func failedSubmissionKeepsState() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.submitResult = .failure(TestError.fixture())

        await questionnairePresenter.onNextTapped()

        #expect(questionnairePresenter.state.loadedContent?.id == "income_stability")
        #expect(questionnairePresenter.answerSelection.selectedAnswerID == "option_1")
        #expect(sessionStoreMock.savedSessionIDs.isEmpty)
        #expect(!questionnairePresenter.isSubmitting)
    }

    @Test("Tapping Next while a submission is in flight doesn't submit again")
    func nextDuringSubmissionIsIgnored() async {
        await questionnairePresenter.startOrResumeSession()
        questionnairePresenter.onSingleChoiceAnswerSelected(answerID: "option_1")
        questionnaireUseCaseMock.holdsSubmissions = true

        let firstSubmission = Task {
            await questionnairePresenter.onNextTapped()
        }
        while questionnaireUseCaseMock.submissions.isEmpty {
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

    @Test("Tapping Back navigates to the intro")
    func backNavigatesToIntro() {
        questionnairePresenter.onBackTapped()

        #expect(routerSpy.calls == [.intro])
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

}

private extension QuestionnairePresenterTests {

    enum Constants {

        static let yieldCount = 10

    }

}
