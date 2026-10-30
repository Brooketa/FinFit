import Foundation
import Testing
@testable import HealthCheck

@Suite("QuestionnaireDataSource")
final class QuestionnaireDataSourceTests {

    private let questionnaireNetworkClientMock = QuestionnaireNetworkClientMock()
    private let questionnaireDataSource: QuestionnaireDataSource

    init() {
        questionnaireDataSource = QuestionnaireDataSource(questionnaireNetworkClient: questionnaireNetworkClientMock)
    }

    @Test("Starting or resuming a session forwards the session id to the client")
    func startOrResumeSessionForwardsID() async throws {
        let sessionID = UUID()

        _ = try await questionnaireDataSource.startOrResumeSession(id: sessionID)

        #expect(questionnaireNetworkClientMock.startedSessionIDs == [sessionID])
    }

    @Test(
        "Submitting an answer forwards the session id, question id and the answer in its client form",
        arguments: [
            (AnswerDataSourceModel.option("unpredictable"), AnswerClientModel.option("unpredictable")),
            (.options(["retirement", "home"]), .options(["retirement", "home"])),
            (.number(2500), .number(2500))
        ])
    func submitAnswerForwardsSubmission(answer: AnswerDataSourceModel, clientAnswer: AnswerClientModel) async throws {
        let sessionID = UUID()

        _ = try await questionnaireDataSource.submitAnswer(sessionID: sessionID, questionID: "goal", answer: answer)

        let submission = try #require(questionnaireNetworkClientMock.submissions.first)
        #expect(questionnaireNetworkClientMock.submissions.count == 1)
        #expect(submission.sessionID == sessionID)
        #expect(submission.questionID == "goal")
        #expect(submission.answer == clientAnswer)
    }

    @Test("An in-progress session is mapped with its id, status, question and progress intact")
    func inProgressSessionIsMapped() async throws {
        let sessionID = UUID()
        questionnaireNetworkClientMock.result = .success(.fixture(
            sessionId: sessionID,
            question: .fixture(
                id: "investment_goals",
                title: "What are you investing for?",
                description: "Select up to three goals.",
                type: .multipleChoice,
                options: [.fixture(id: "retirement", title: "Retirement"), .fixture(id: "home", title: "Buying a home")],
                validation: .fixture(required: true, min: 1, max: 9, minSelections: 1, maxSelections: 3)),
            progress: .fixture(current: 2, total: 5)))

        let session = try await questionnaireDataSource.startOrResumeSession(id: sessionID)

        #expect(session.id == sessionID)
        #expect(session.status == .inProgress)
        #expect(session.result == nil)
        #expect(session.progress.current == 2)
        #expect(session.progress.total == 5)
        let question = try #require(session.question)
        #expect(question.id == "investment_goals")
        #expect(question.title == "What are you investing for?")
        #expect(question.description == "Select up to three goals.")
        #expect(question.type == .multipleChoice)
        #expect(question.options?.map(\.id) == ["retirement", "home"])
        #expect(question.options?.map(\.title) == ["Retirement", "Buying a home"])
        #expect(question.validation?.required == true)
        #expect(question.validation?.min == 1)
        #expect(question.validation?.max == 9)
        #expect(question.validation?.minSelections == 1)
        #expect(question.validation?.maxSelections == 3)
    }

    @Test(
        "Each question type maps to its data source form",
        arguments: [
            (QuestionClientModel.QuestionType.singleChoice, QuestionDataSourceModel.QuestionType.singleChoice),
            (.multipleChoice, .multipleChoice),
            (.number, .number)
        ])
    func questionTypeIsMapped(
        type: QuestionClientModel.QuestionType,
        expectedType: QuestionDataSourceModel.QuestionType
    ) async throws {
        questionnaireNetworkClientMock.result = .success(.fixture(question: .fixture(type: type)))

        let session = try await questionnaireDataSource.startOrResumeSession(id: UUID())

        #expect(session.question?.type == expectedType)
    }

    @Test(
        "A completed session is mapped with its result",
        arguments: [
            (ResultClientModel.Category.poor, ResultDataSourceModel.Category.poor),
            (.fair, .fair),
            (.good, .good),
            (.excellent, .excellent)
        ])
    func completedSessionIsMapped(
        category: ResultClientModel.Category,
        expectedCategory: ResultDataSourceModel.Category
    ) async throws {
        questionnaireNetworkClientMock.result = .success(.fixture(
            status: .completed,
            question: nil,
            result: .fixture(score: 64, category: category),
            progress: .fixture(current: 5, total: 5)))

        let session = try await questionnaireDataSource.submitAnswer(
            sessionID: UUID(),
            questionID: "goal",
            answer: .number(1))

        #expect(session.status == .completed)
        #expect(session.question == nil)
        #expect(session.result?.score == 64)
        #expect(session.result?.category == expectedCategory)
    }

    @Test("Missing optional values stay missing after mapping")
    func missingValuesStayMissing() async throws {
        questionnaireNetworkClientMock.result = .success(.fixture(
            question: .fixture(description: nil, type: .number, options: nil, validation: nil)))

        let session = try await questionnaireDataSource.startOrResumeSession(id: UUID())

        let question = try #require(session.question)
        #expect(question.description == nil)
        #expect(question.options == nil)
        #expect(question.validation == nil)
        #expect(session.result == nil)
    }

    @Test("Missing validation values stay missing after mapping")
    func missingValidationValuesStayMissing() async throws {
        let question = QuestionClientModel.fixture(validation: .fixture(required: nil))
        questionnaireNetworkClientMock.result = .success(.fixture(question: question))

        let session = try await questionnaireDataSource.startOrResumeSession(id: UUID())

        let validation = try #require(session.question?.validation)
        #expect(validation.required == nil)
        #expect(validation.min == nil)
        #expect(validation.max == nil)
        #expect(validation.minSelections == nil)
        #expect(validation.maxSelections == nil)
    }

    @Test("Errors from the client are rethrown")
    func rethrowsClientErrors() async throws {
        questionnaireNetworkClientMock.result = .failure(TestError.fixture())

        await #expect(throws: TestError.fixture()) {
            _ = try await self.questionnaireDataSource.startOrResumeSession(id: UUID())
        }
        await #expect(throws: TestError.fixture()) {
            _ = try await self.questionnaireDataSource.submitAnswer(
                sessionID: UUID(),
                questionID: "goal",
                answer: .number(1))
        }
    }

}
