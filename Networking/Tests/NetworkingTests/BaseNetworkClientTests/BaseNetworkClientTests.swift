import Foundation
import Testing
@testable import Networking

@Suite("BaseNetworkClient", .serialized)
final class BaseNetworkClientTests {

    private let baseNetworkClient: BaseNetworkClient

    init() {
        StubURLProtocol.reset()
        baseNetworkClient = BaseNetworkClient(baseURL: Constants.baseURL, urlSession: .fixture())
    }

    @Test("The request URL is the base URL followed by the endpoint's path and query parameters")
    func requestURLIsBuiltFromBaseURLPathAndQuery() async throws {
        let endpoint = TestEndpoint.fixture(path: "/sessions/1", queryParameters: ["page": "2", "size": "10"])

        let _: TestResponse = try await baseNetworkClient.request(endpoint)

        let url = try #require(StubURLProtocol.receivedRequest?.url)
        let components = try #require(URLComponents(url: url, resolvingAgainstBaseURL: false))
        #expect(components.scheme == "https")
        #expect(components.host == "api.finfit.test")
        #expect(components.path == "/sessions/1")
        #expect(Set(components.queryItems ?? []) == [
            URLQueryItem(name: "page", value: "2"),
            URLQueryItem(name: "size", value: "10")
        ])
    }

    @Test("The request has the endpoint's method, a JSON content type and the endpoint's headers")
    func requestHasMethodContentTypeAndHeaders() async throws {
        let endpoint = TestEndpoint.fixture(method: .put, headers: ["x-session": "abc"])

        let _: TestResponse = try await baseNetworkClient.request(endpoint)

        let request = try #require(StubURLProtocol.receivedRequest)
        #expect(request.httpMethod == "PUT")
        #expect(request.value(forHTTPHeaderField: "content-type") == "application/json")
        #expect(request.value(forHTTPHeaderField: "x-session") == "abc")
    }

    @Test("An endpoint with a body sends it JSON-encoded")
    func bodyIsSentJSONEncoded() async throws {
        let _: TestResponse = try await baseNetworkClient.request(TestEndpoint.fixture(body: TestBody.fixture()))

        let body = try #require(StubURLProtocol.receivedBody)
        #expect(try JSONDecoder().decode(TestBody.self, from: body) == .fixture())
    }

    @Test("An endpoint without a body sends no body")
    func noBodyIsSentWithoutOne() async throws {
        let _: TestResponse = try await baseNetworkClient.request(TestEndpoint.fixture())

        #expect(StubURLProtocol.receivedBody == nil)
    }

    @Test("A 2xx response with valid JSON is decoded into the requested type")
    func successfulResponseIsDecoded() async throws {
        StubURLProtocol.response = .success(.fixture(statusCode: 201))

        let response: TestResponse = try await baseNetworkClient.request(TestEndpoint.fixture())

        #expect(response == .fixture())
    }

    @Test("A non-2xx status throws unexpectedStatusCode with that status")
    func nonSuccessStatusThrows() async throws {
        StubURLProtocol.response = .success(.fixture(statusCode: 400))

        let error = await #expect(throws: APIError.self) {
            let _: TestResponse = try await self.baseNetworkClient.request(TestEndpoint.fixture())
        }

        #expect(error?.unexpectedStatusCode == 400)
    }

    @Test("A transport failure throws requestFailed")
    func transportFailureThrows() async throws {
        StubURLProtocol.response = .failure(URLError(.notConnectedToInternet))

        let error = await #expect(throws: APIError.self) {
            let _: TestResponse = try await self.baseNetworkClient.request(TestEndpoint.fixture())
        }

        #expect(error?.isRequestFailed == true)
    }

    @Test("A response body that doesn't match the requested type throws decodingFailed")
    func mismatchedBodyThrows() async throws {
        StubURLProtocol.response = .success(.fixture(data: Data("[1, 2, 3]".utf8)))

        let error = await #expect(throws: APIError.self) {
            let _: TestResponse = try await self.baseNetworkClient.request(TestEndpoint.fixture())
        }

        #expect(error?.isDecodingFailed == true)
    }

    @Test("A base URL that can't form a URL throws invalidURL")
    func invalidBaseURLThrows() async throws {
        let baseNetworkClient = BaseNetworkClient(baseURL: Constants.invalidBaseURL, urlSession: .fixture())

        let error = await #expect(throws: APIError.self) {
            let _: TestResponse = try await baseNetworkClient.request(TestEndpoint.fixture())
        }

        #expect(error?.isInvalidURL == true)
        #expect(StubURLProtocol.receivedRequest == nil)
    }

    @Test("A body that can't be encoded throws encodingFailed")
    func unencodableBodyThrows() async throws {
        let error = await #expect(throws: APIError.self) {
            let _: TestResponse = try await self.baseNetworkClient.request(TestEndpoint.fixture(body: UnencodableBody()))
        }

        #expect(error?.isEncodingFailed == true)
        #expect(StubURLProtocol.receivedRequest == nil)
    }

}

private extension BaseNetworkClientTests {

    enum Constants {

        static let baseURL = "https://api.finfit.test"
        static let invalidBaseURL = "http://[::1"

    }

}
