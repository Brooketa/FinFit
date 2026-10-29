public protocol Endpoint: Sendable {

    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String] { get }
    var headers: [String: String] { get }
    var body: (any Encodable & Sendable)? { get }

}

public extension Endpoint {

    var queryParameters: [String: String] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }

    var body: (any Encodable & Sendable)? {
        nil
    }

}
