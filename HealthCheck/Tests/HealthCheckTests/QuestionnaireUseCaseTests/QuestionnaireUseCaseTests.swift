import Foundation
import Testing
@testable import HealthCheck

@Suite("QuestionnaireUseCase")
final class QuestionnaireUseCaseTests {

    private let questionnaireRepositoryMock = QuestionnaireRepositoryMock()
    private let questionnaireUseCase: QuestionnaireUseCase

    init() {
        questionnaireUseCase = QuestionnaireUseCase(questionnaireRepository: questionnaireRepositoryMock)
    }

    @Test("Starting or resuming a session forwards the session id to the repository")
    func startOrResumeSessionForwardsID() async throws {
        let sessionID = UUID()

        _ = try await questionnaireUseCase.startOrResumeSession(id: sessionID)

        #expect(questionnaireRepositoryMock.startedSessionIDs == [sessionID])
    }

    @Test(
        "Submitting an answer forwards the session id, question id and the answer in its repository form",
        arguments: [
            (AnswerUseCaseModel.option("unpredictable"), AnswerRepositoryModel.option("unpredictable")),
            (.options(["retirement", "home"]), .options(["retirement", "home"])),
            (.number(2500), .number(2500))
        ])
    func submitAnswerForwardsSubmission(
        answer: AnswerUseCaseModel,
        repositoryAnswer: AnswerRepositoryModel
    ) async throws {
        let sessionID = UUID()

        _ = try await questionnaireUseCase.submitAnswer(sessionID: sessionID, questionID: "goal", answer: answer)

        let submission = try #require(questionnaireRepositoryMock.submissions.first)
        #expect(questionnaireRepositoryMock.submissions.count == 1)
        #expect(submission.sessionID == sessionID)
        #expect(submission.questionID == "goal")
        #expect(submission.answer == repositoryAnswer)
    }

    @Test("An in-progress session with a question becomes that question with its progress")
    func inProgressSessionBecomesQuestion() async throws {
        questionnaireRepositoryMock.result = .success(.fixture(
            question: .fixture(
                id: "income_stability",
                title: "How predictable is your income?",
                description: "Think about the last year.",
                type: .singleChoice,
                options: [.fixture(id: "very_stable"), .fixture(id: "unpredictable")]),
            progress: .fixture(current: 2, total: 5)))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        let question = try #require(session.question)
        #expect(question.id == "income_stability")
        #expect(question.title == "How predictable is your income?")
        #expect(question.description == "Think about the last year.")
        #expect(question.type.optionIDs == ["very_stable", "unpredictable"])
        #expect(session.progress?.current == 2)
        #expect(session.progress?.total == 5)
    }

    @Test(
        "A completed session with a result becomes that result with its category",
        arguments: [
            (ResultRepositoryModel.Category.poor, ResultUseCaseModel.Category.poor),
            (.fair, .fair),
            (.good, .good),
            (.excellent, .excellent)
        ])
    func completedSessionBecomesResult(
        category: ResultRepositoryModel.Category,
        expectedCategory: ResultUseCaseModel.Category
    ) async throws {
        questionnaireRepositoryMock.result = .success(.fixture(
            status: .completed,
            question: nil,
            result: .fixture(score: 64, category: category)))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        #expect(session.result?.score == 64)
        #expect(session.result?.category == expectedCategory)
        #expect(session.question == nil)
    }

    @Test("An in-progress session without a question throws invalidSession")
    func inProgressSessionWithoutQuestionThrows() async throws {
        questionnaireRepositoryMock.result = .success(.fixture(status: .inProgress, question: nil))

        await #expect(throws: QuestionnaireUseCaseError.invalidSession) {
            _ = try await self.questionnaireUseCase.startOrResumeSession(id: UUID())
        }
    }

    @Test("A completed session without a result throws invalidSession")
    func completedSessionWithoutResultThrows() async throws {
        questionnaireRepositoryMock.result = .success(.fixture(status: .completed, question: nil, result: nil))

        await #expect(throws: QuestionnaireUseCaseError.invalidSession) {
            _ = try await self.questionnaireUseCase.submitAnswer(
                sessionID: UUID(),
                questionID: "goal",
                answer: .number(1))
        }
    }

    @Test("A multiple-choice question's selection range follows its limits", arguments: SelectionRangeCase.fixtures)
    func selectionRangeFollowsLimits(selectionRangeCase: SelectionRangeCase) async throws {
        questionnaireRepositoryMock.result = .success(.fixture(question: .fixture(
            type: .multipleChoice,
            options: OptionRepositoryModel.fixtures(count: selectionRangeCase.optionCount),
            validation: .fixture(
                required: selectionRangeCase.required,
                minSelections: selectionRangeCase.minSelections,
                maxSelections: selectionRangeCase.maxSelections))))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        #expect(session.question?.type.selectionRange == selectionRangeCase.expectedRange)
    }

    @Test("A multiple-choice question without validation allows none to every option")
    func selectionRangeWithoutValidation() async throws {
        questionnaireRepositoryMock.result = .success(.fixture(question: .fixture(
            type: .multipleChoice,
            options: OptionRepositoryModel.fixtures(count: 5),
            validation: nil)))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        #expect(session.question?.type.selectionRange == 0...5)
    }

    @Test("A number question's range follows its limits", arguments: ValueRangeCase.fixtures)
    func valueRangeFollowsLimits(valueRangeCase: ValueRangeCase) async throws {
        questionnaireRepositoryMock.result = .success(.fixture(question: .fixture(
            type: .number,
            options: nil,
            validation: .fixture(min: valueRangeCase.min, max: valueRangeCase.max))))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        #expect(session.question?.type.valueRange == valueRangeCase.expectedRange)
    }

    @Test(
        "A question is required only when its validation says so",
        arguments: [
            (ValidationRepositoryModel?.some(.fixture(required: true)), true),
            (.some(.fixture(required: false)), false),
            (.some(.fixture(required: nil)), false),
            (nil, false)
        ])
    func isRequiredFollowsValidation(validation: ValidationRepositoryModel?, expectedIsRequired: Bool) async throws {
        questionnaireRepositoryMock.result = .success(.fixture(question: .fixture(validation: validation)))

        let session = try await questionnaireUseCase.startOrResumeSession(id: UUID())

        #expect(session.question?.isRequired == expectedIsRequired)
    }

    @Test("Errors from the repository are rethrown")
    func rethrowsRepositoryErrors() async throws {
        questionnaireRepositoryMock.result = .failure(TestError.fixture())

        await #expect(throws: TestError.fixture()) {
            _ = try await self.questionnaireUseCase.startOrResumeSession(id: UUID())
        }
        await #expect(throws: TestError.fixture()) {
            _ = try await self.questionnaireUseCase.submitAnswer(
                sessionID: UUID(),
                questionID: "goal",
                answer: .number(1))
        }
    }

}
