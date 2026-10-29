import Foundation

extension URLRequest {

    init(endpoint: some Endpoint, baseURL: String) throws {
        guard var url = URL(string: "\(baseURL)\(endpoint.path)") else { throw APIError.invalidURL }

        let queryItems = endpoint.queryParameters.map { name, value in
            URLQueryItem(name: name, value: value)
        }
        url.append(queryItems: queryItems)

        self.init(url: url)
        httpMethod = endpoint.method.rawValue
        setValue("application/json", forHTTPHeaderField: "content-type")

        for (field, value) in endpoint.headers {
            setValue(value, forHTTPHeaderField: field)
        }

        if let body = endpoint.body {
            httpBody = try Self.encode(body)
        }
    }

    private static func encode(_ body: any Encodable) throws -> Data {
        do {
            return try JSONEncoder().encode(body)
        } catch {
            throw APIError.encodingFailed(error)
        }
    }

}
