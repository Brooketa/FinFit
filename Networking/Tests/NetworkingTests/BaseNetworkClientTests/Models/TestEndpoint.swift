import Networking

struct TestEndpoint: Endpoint {

    let path: String
    let method: HTTPMethod
    let queryParameters: [String: String]
    let headers: [String: String]
    let body: (any Encodable & Sendable)?

}
