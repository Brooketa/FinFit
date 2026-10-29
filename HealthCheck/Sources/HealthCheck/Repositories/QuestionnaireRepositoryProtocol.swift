import Foundation

protocol QuestionnaireRepositoryProtocol: Sendable {

    func startOrResumeSession(id: UUID) async throws -> SessionRepositoryModel
    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerRepositoryModel
    ) async throws -> SessionRepositoryModel

}
