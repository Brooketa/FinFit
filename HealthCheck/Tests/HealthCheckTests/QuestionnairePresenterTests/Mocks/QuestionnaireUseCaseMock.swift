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

    private(set) var startedSessionIDs: [UUID] = []
    private(set) var submissions: [Submission] = []

    private let lock = NSLock()
    private var holdsStarts = false
    private var holdsSubmissions = false
    private var heldStarts: [CheckedContinuation<Void, Never>] = []
    private var heldSubmissions: [CheckedContinuation<Void, Never>] = []

    var heldStartCount: Int {
        lock.withLock { heldStarts.count }
    }

    var heldSubmissionCount: Int {
        lock.withLock { heldSubmissions.count }
    }

    func startOrResumeSession(id: UUID) async throws -> SessionUseCaseModel {
        startedSessionIDs.append(id)
        await withCheckedContinuation { continuation in
            lock.withLock {
                guard holdsStarts else { return continuation.resume() }

                heldStarts.append(continuation)
            }
        }

        return try startResult.get()
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerUseCaseModel
    ) async throws -> SessionUseCaseModel {
        submissions.append(Submission(sessionID: sessionID, questionID: questionID, answer: answer))
        await withCheckedContinuation { continuation in
            lock.withLock {
                guard holdsSubmissions else { return continuation.resume() }

                heldSubmissions.append(continuation)
            }
        }

        return try submitResult.get()
    }

    func holdStarts() {
        lock.withLock { holdsStarts = true }
    }

    func holdSubmissions() {
        lock.withLock { holdsSubmissions = true }
    }

    func releaseStarts() {
        let continuations = lock.withLock {
            holdsStarts = false
            defer { heldStarts.removeAll() }

            return heldStarts
        }
        continuations.forEach { $0.resume() }
    }

    func releaseSubmissions() {
        let continuations = lock.withLock {
            holdsSubmissions = false
            defer { heldSubmissions.removeAll() }

            return heldSubmissions
        }
        continuations.forEach { $0.resume() }
    }

}
