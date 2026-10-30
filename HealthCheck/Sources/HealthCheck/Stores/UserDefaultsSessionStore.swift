import Foundation
import Core

final class UserDefaultsSessionStore: SessionStoreProtocol {

    private let userDefaultsService: any UserDefaultsServiceProtocol

    init(userDefaultsService: any UserDefaultsServiceProtocol) {
        self.userDefaultsService = userDefaultsService
    }

    var sessionID: UUID? {
        try? userDefaultsService.read(forKey: Constants.sessionIDKey)
    }

    func save(sessionID: UUID) {
        try? userDefaultsService.write(sessionID, forKey: Constants.sessionIDKey)
    }

    func removeSessionID() {
        userDefaultsService.remove(forKey: Constants.sessionIDKey)
    }

}

private extension UserDefaultsSessionStore {

    enum Constants {

        static let sessionIDKey = "healthCheckSessionID"

    }

}
