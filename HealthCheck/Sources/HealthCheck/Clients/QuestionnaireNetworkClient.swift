import Foundation
import Networking

final class QuestionnaireNetworkClient: QuestionnaireNetworkClientProtocol {

    private let baseNetworkClient: any BaseNetworkClientProtocol

    init(baseNetworkClient: any BaseNetworkClientProtocol) {
        self.baseNetworkClient = baseNetworkClient
    }

    func startOrResumeSession(id: UUID) async throws -> SessionClientModel {
        try await baseNetworkClient.request(QuestionnaireEndpoint.startOrResumeSession(id: id))
    }

}
