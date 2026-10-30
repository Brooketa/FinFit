import Foundation

public protocol UserDefaultsServiceProtocol {

    /// The value saved under `key`, decoded from JSON, or `nil` if nothing is saved there.
    func read<Value: Decodable>(forKey key: String) throws -> Value?

    /// Saves `value` under `key`, encoded as JSON, replacing anything saved there.
    func write<Value: Encodable>(_ value: Value, forKey key: String) throws

    /// Removes whatever is saved under `key`.
    func remove(forKey key: String)

}
