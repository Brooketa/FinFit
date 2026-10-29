import Foundation

public final class BaseNetworkClient: BaseNetworkClientProtocol {

    private let baseURL: String
    private let urlSession: URLSession

    public init(baseURL: String, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    public func request<ResponseType: Decodable>(_ endpoint: some Endpoint) async throws -> ResponseType {
        let request = try URLRequest(endpoint: endpoint, baseURL: baseURL)
        let (data, response) = try await execute(request)
        try validate(response)

        return try decode(ResponseType.self, from: data)
    }

    private func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await urlSession.data(for: request)
        } catch {
            throw APIError.requestFailed(error)
        }
    }

    private func validate(_ response: URLResponse) throws {
        guard let httpURLResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200...299).contains(httpURLResponse.statusCode) else {
            throw APIError.unexpectedStatusCode(httpURLResponse.statusCode)
        }
    }

    private func decode<ResponseType: Decodable>(_ type: ResponseType.Type, from data: Data) throws -> ResponseType {
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

}
