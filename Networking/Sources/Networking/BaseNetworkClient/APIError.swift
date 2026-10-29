public enum APIError: Error {

    case invalidURL
    case encodingFailed(any Error)
    case requestFailed(any Error)
    case invalidResponse
    case unexpectedStatusCode(Int)
    case decodingFailed(any Error)

}
