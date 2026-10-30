import Foundation
@testable import HealthCheck

final class QuestionnaireDataSourceMock: QuestionnaireDataSourceProtocol, @unchecked Sendable {

    struct Submission {

        let sessionID: UUID
        let questionID: String
        let answer: AnswerDataSourceModel

    }

    var result: Result<SessionDataSourceModel, any Error> = .success(.fixture())

    private(set) var startedSessionIDs: [UUID] = []
    private(set) var submissions: [Submission] = []

    func startOrResumeSession(id: UUID) async throws -> SessionDataSourceModel {
        startedSessionIDs.append(id)

        return try result.get()
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerDataSourceModel
    ) async throws -> SessionDataSourceModel {
        submissions.append(Submission(sessionID: sessionID, questionID: questionID, answer: answer))

        return try result.get()
    }

}
