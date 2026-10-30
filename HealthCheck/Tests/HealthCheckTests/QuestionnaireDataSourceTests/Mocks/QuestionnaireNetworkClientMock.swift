import Foundation
@testable import HealthCheck

final class QuestionnaireNetworkClientMock: QuestionnaireNetworkClientProtocol, @unchecked Sendable {

    struct Submission {

        let sessionID: UUID
        let questionID: String
        let answer: AnswerClientModel

    }

    var result: Result<SessionClientModel, any Error> = .success(.fixture())

    private(set) var startedSessionIDs: [UUID] = []
    private(set) var submissions: [Submission] = []

    func startOrResumeSession(id: UUID) async throws -> SessionClientModel {
        startedSessionIDs.append(id)

        return try result.get()
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerClientModel
    ) async throws -> SessionClientModel {
        submissions.append(Submission(sessionID: sessionID, questionID: questionID, answer: answer))

        return try result.get()
    }

}
