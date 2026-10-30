import Foundation
@testable import HealthCheck

final class QuestionnaireRepositoryMock: QuestionnaireRepositoryProtocol, @unchecked Sendable {

    struct Submission {

        let sessionID: UUID
        let questionID: String
        let answer: AnswerRepositoryModel

    }

    var result: Result<SessionRepositoryModel, any Error> = .success(.fixture())

    private(set) var startedSessionIDs: [UUID] = []
    private(set) var submissions: [Submission] = []

    func startOrResumeSession(id: UUID) async throws -> SessionRepositoryModel {
        startedSessionIDs.append(id)

        return try result.get()
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerRepositoryModel
    ) async throws -> SessionRepositoryModel {
        submissions.append(Submission(sessionID: sessionID, questionID: questionID, answer: answer))

        return try result.get()
    }

}
