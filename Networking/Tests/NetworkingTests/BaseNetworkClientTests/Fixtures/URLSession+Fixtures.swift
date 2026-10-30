import Foundation

extension URLSession {

    static func fixture() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]

        return URLSession(configuration: configuration)
    }

}
