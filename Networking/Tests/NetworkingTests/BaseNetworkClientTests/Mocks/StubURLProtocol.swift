import Foundation

final class StubURLProtocol: URLProtocol {

    nonisolated(unsafe) static var response: Result<StubResponse, any Error> = .success(.fixture())
    nonisolated(unsafe) static var receivedRequest: URLRequest?
    nonisolated(unsafe) static var receivedBody: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    static func reset() {
        response = .success(.fixture())
        receivedRequest = nil
        receivedBody = nil
    }

    override func startLoading() {
        Self.receivedRequest = request
        Self.receivedBody = request.httpBody ?? request.httpBodyStream.map { Data(reading: $0) }

        switch Self.response {
        case .success(let stubResponse):
            let urlResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: stubResponse.statusCode,
                httpVersion: nil,
                headerFields: nil)!
            client?.urlProtocol(self, didReceive: urlResponse, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: stubResponse.data)
            client?.urlProtocolDidFinishLoading(self)
        case .failure(let error):
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}

}
