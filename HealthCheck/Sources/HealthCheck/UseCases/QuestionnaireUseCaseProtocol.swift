import Foundation

protocol QuestionnaireUseCaseProtocol: Sendable {

    func startOrResumeSession(id: UUID) async throws -> SessionUseCaseModel
    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerUseCaseModel
    ) async throws -> SessionUseCaseModel

}
