import Foundation
import Testing
@testable import HealthCheck

@Suite("QuestionnaireNetworkClient")
final class QuestionnaireNetworkClientTests {

    private let baseNetworkClientMock = BaseNetworkClientMock()
    private let questionnaireNetworkClient: QuestionnaireNetworkClient

    init() {
        questionnaireNetworkClient = QuestionnaireNetworkClient(baseNetworkClient: baseNetworkClientMock)
    }

    @Test("Starting or resuming a session sends a POST to the session's path, with the id lowercased and no body")
    func startOrResumeSessionSendsSessionEndpoint() async throws {
        let sessionID = try #require(UUID(uuidString: Constants.sessionID))

        _ = try await questionnaireNetworkClient.startOrResumeSession(id: sessionID)

        let endpoint = try #require(baseNetworkClientMock.receivedEndpoints.first)
        #expect(baseNetworkClientMock.receivedEndpoints.count == 1)
        #expect(endpoint.path == "/health-check/v1/sessions/\(Constants.sessionID.lowercased())")
        #expect(endpoint.method == .post)
        #expect(endpoint.body == nil)
    }

    @Test("Submitting an answer sends a POST to the session's submission path, with the question and answer as body")
    func submitAnswerSendsSubmissionEndpoint() async throws {
        let sessionID = try #require(UUID(uuidString: Constants.sessionID))

        _ = try await questionnaireNetworkClient.submitAnswer(
            sessionID: sessionID,
            questionID: "monthly_income",
            answer: .number(2500))

        let endpoint = try #require(baseNetworkClientMock.receivedEndpoints.first)
        #expect(endpoint.path == "/health-check/v1/sessions/\(Constants.sessionID.lowercased())/submission")
        #expect(endpoint.method == .post)
        let body = try #require(endpoint.body)
        #expect(try jsonObject(encoding: body) == ["questionId": "monthly_income", "answer": 2500])
    }

    @Test("The session the base client returns is returned unchanged")
    func returnsTheBaseClientSession() async throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.numberSession)
        baseNetworkClientMock.result = .success(session)

        let returnedSession = try await questionnaireNetworkClient.startOrResumeSession(id: UUID())

        #expect(returnedSession.sessionId == session.sessionId)
        #expect(returnedSession.status == session.status)
        #expect(returnedSession.question?.id == "emergency_fund")
        #expect(returnedSession.progress.current == 2)
    }

    @Test("Errors from the base client are rethrown")
    func rethrowsBaseClientErrors() async throws {
        baseNetworkClientMock.result = .failure(TestError.fixture())

        await #expect(throws: TestError.fixture()) {
            _ = try await self.questionnaireNetworkClient.submitAnswer(
                sessionID: UUID(),
                questionID: "monthly_income",
                answer: .number(2500))
        }
    }

    private func jsonObject(encoding value: any Encodable) throws -> NSDictionary {
        let data = try JSONEncoder().encode(value)

        return try #require(JSONSerialization.jsonObject(with: data) as? NSDictionary)
    }

}

private extension QuestionnaireNetworkClientTests {

    enum Constants {

        static let sessionID = "9CF3DC4B-7E4E-4073-BD4C-12AADFDF4930"

    }

}
