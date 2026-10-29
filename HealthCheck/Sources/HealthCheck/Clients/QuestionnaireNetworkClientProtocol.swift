import Foundation

protocol QuestionnaireNetworkClientProtocol: Sendable {

    func startOrResumeSession(id: UUID) async throws -> SessionClientModel
    func submitAnswer(sessionID: UUID, questionID: String, answer: AnswerClientModel) async throws -> SessionClientModel

}
