import Foundation

protocol QuestionnaireNetworkClientProtocol: Sendable {

    func startOrResumeSession(id: UUID) async throws -> SessionClientModel

}
