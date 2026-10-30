import FactoryKit

extension Container {

    // MARK: Services

    /// The shared `UserDefaults` service, reading and writing `UserDefaults.standard`.
    public var userDefaultsService: Factory<any UserDefaultsServiceProtocol> {
        self { UserDefaultsService(userDefaults: .standard) }
    }

}
