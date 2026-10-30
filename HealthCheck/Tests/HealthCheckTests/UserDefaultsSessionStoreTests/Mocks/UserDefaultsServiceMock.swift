import Core

final class UserDefaultsServiceMock: UserDefaultsServiceProtocol {

    var readError: (any Error)?
    var writeError: (any Error)?

    private(set) var values: [String: Any] = [:]
    private(set) var writtenKeys: [String] = []
    private(set) var removedKeys: [String] = []

    func read<Value: Decodable>(forKey key: String) throws -> Value? {
        if let readError {
            throw readError
        }

        return values[key] as? Value
    }

    func write<Value: Encodable>(_ value: Value, forKey key: String) throws {
        if let writeError {
            throw writeError
        }

        writtenKeys.append(key)
        values[key] = value
    }

    func remove(forKey key: String) {
        removedKeys.append(key)
        values[key] = nil
    }

}
