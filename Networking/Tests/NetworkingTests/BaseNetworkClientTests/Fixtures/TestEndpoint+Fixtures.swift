import Networking

extension TestEndpoint {

    static func fixture(
        path: String = "/health-check/v1/sessions/1",
        method: HTTPMethod = .post,
        queryParameters: [String: String] = [:],
        headers: [String: String] = [:],
        body: (any Encodable & Sendable)? = nil
    ) -> TestEndpoint {
        TestEndpoint(path: path, method: method, queryParameters: queryParameters, headers: headers, body: body)
    }

}
