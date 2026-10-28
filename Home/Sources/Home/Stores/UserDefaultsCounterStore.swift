import Foundation

final class UserDefaultsCounterStore {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

}

// MARK: CounterStoreProtocol

extension UserDefaultsCounterStore: CounterStoreProtocol {

    var count: Int {
        userDefaults.integer(forKey: Constants.countKey)
    }

    func save(count: Int) {
        userDefaults.set(count, forKey: Constants.countKey)
    }

}

private extension UserDefaultsCounterStore {

    enum Constants {

        static let countKey = "home.counter.count"

    }

}
