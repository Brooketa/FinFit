import Networking

extension APIError {

    var isInvalidURL: Bool {
        guard case .invalidURL = self else { return false }

        return true
    }

    var isEncodingFailed: Bool {
        guard case .encodingFailed = self else { return false }

        return true
    }

    var isRequestFailed: Bool {
        guard case .requestFailed = self else { return false }

        return true
    }

    var isDecodingFailed: Bool {
        guard case .decodingFailed = self else { return false }

        return true
    }

    var unexpectedStatusCode: Int? {
        guard case .unexpectedStatusCode(let statusCode) = self else { return nil }

        return statusCode
    }

}
