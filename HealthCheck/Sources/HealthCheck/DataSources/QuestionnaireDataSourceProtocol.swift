import Foundation

protocol QuestionnaireDataSourceProtocol: Sendable {

    func startOrResumeSession(id: UUID) async throws -> SessionDataSourceModel
    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerDataSourceModel
    ) async throws -> SessionDataSourceModel

}
