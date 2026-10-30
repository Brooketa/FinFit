import Foundation
@testable import HealthCheck

final class QuestionnaireUseCaseMock: QuestionnaireUseCaseProtocol, @unchecked Sendable {

    struct Submission {

        let sessionID: UUID
        let questionID: String
        let answer: AnswerUseCaseModel

    }

    var startResult: Result<SessionUseCaseModel, any Error> = .success(.fixture())
    var submitResult: Result<SessionUseCaseModel, any Error> = .success(.fixture())
    var holdsSubmissions = false

    private(set) var startedSessionIDs: [UUID] = []
    private(set) var submissions: [Submission] = []

    private var heldSubmission: CheckedContinuation<Void, Never>?

    func startOrResumeSession(id: UUID) async throws -> SessionUseCaseModel {
        startedSessionIDs.append(id)

        return try startResult.get()
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerUseCaseModel
    ) async throws -> SessionUseCaseModel {
        submissions.append(Submission(sessionID: sessionID, questionID: questionID, answer: answer))

        if holdsSubmissions {
            await withCheckedContinuation { heldSubmission = $0 }
        }

        return try submitResult.get()
    }

    func releaseSubmission() {
        heldSubmission?.resume()
        heldSubmission = nil
    }

}
