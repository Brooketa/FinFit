import Foundation
import Testing
@testable import Core

@Suite("UserDefaultsService")
final class UserDefaultsServiceTests {

    private let suiteName: String
    private let userDefaultsService: UserDefaultsService

    init() {
        suiteName = "UserDefaultsServiceTests.\(UUID().uuidString)"
        userDefaultsService = UserDefaultsService(userDefaults: UserDefaults(suiteName: suiteName)!)
    }

    deinit {
        UserDefaults().removePersistentDomain(forName: suiteName)
    }

    @Test("A written value is read back unchanged")
    func writtenValueReadsBack() throws {
        try userDefaultsService.write(StoredValue.fixture(), forKey: Constants.key)

        let value: StoredValue? = try userDefaultsService.read(forKey: Constants.key)

        #expect(value == .fixture())
    }

    @Test("Reading a key that was never written returns nil")
    func missingKeyReadsAsNil() throws {
        let value: StoredValue? = try userDefaultsService.read(forKey: Constants.missingKey)

        #expect(value == nil)
    }

    @Test("Writing to an existing key replaces the previous value")
    func writingAgainReplacesTheValue() throws {
        let replacement = StoredValue.fixture(name: "Retirement", count: 5)
        try userDefaultsService.write(StoredValue.fixture(), forKey: Constants.key)
        try userDefaultsService.write(replacement, forKey: Constants.key)

        let value: StoredValue? = try userDefaultsService.read(forKey: Constants.key)

        #expect(value == replacement)
    }

    @Test("Removing a key clears its stored value")
    func removingAKeyClearsIt() throws {
        try userDefaultsService.write(StoredValue.fixture(), forKey: Constants.key)

        userDefaultsService.remove(forKey: Constants.key)

        let value: StoredValue? = try userDefaultsService.read(forKey: Constants.key)
        #expect(value == nil)
    }

    @Test("Reading a value as an incompatible type throws")
    func undecodableDataThrows() throws {
        try userDefaultsService.write(StoredValue.fixture(), forKey: Constants.key)

        #expect(throws: DecodingError.self) {
            let _: Int? = try userDefaultsService.read(forKey: Constants.key)
        }
    }

}

private extension UserDefaultsServiceTests {

    enum Constants {

        static let key = "storedValue"
        static let missingKey = "missingValue"

    }

}
