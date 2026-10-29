public protocol BaseNetworkClientProtocol: Sendable {

    func request<ResponseType: Decodable>(_ endpoint: some Endpoint) async throws -> ResponseType

}
