import Networking
@testable import HealthCheck

final class BaseNetworkClientMock: BaseNetworkClientProtocol, @unchecked Sendable {

    var result: Result<SessionClientModel, any Error> = .success(.fixture())

    private(set) var receivedEndpoints: [QuestionnaireEndpoint] = []

    func request<ResponseType: Decodable>(_ endpoint: some Endpoint) async throws -> ResponseType {
        if let questionnaireEndpoint = endpoint as? QuestionnaireEndpoint {
            receivedEndpoints.append(questionnaireEndpoint)
        }

        return try result.get() as! ResponseType
    }

}
