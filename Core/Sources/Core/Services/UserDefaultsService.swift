import Foundation

public final class UserDefaultsService: UserDefaultsServiceProtocol {

    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    /// A service reading and writing JSON-encoded values in `userDefaults`.
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func read<Value: Decodable>(forKey key: String) throws -> Value? {
        guard let data = userDefaults.data(forKey: key) else { return nil }

        return try decoder.decode(Value.self, from: data)
    }

    public func write<Value: Encodable>(_ value: Value, forKey key: String) throws {
        let data = try encoder.encode(value)
        userDefaults.set(data, forKey: key)
    }

    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }

}
