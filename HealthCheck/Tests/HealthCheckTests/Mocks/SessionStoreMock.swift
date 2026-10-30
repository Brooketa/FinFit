import Foundation
@testable import HealthCheck

final class SessionStoreMock: SessionStoreProtocol {

    private(set) var sessionID: UUID?
    private(set) var savedSessionIDs: [UUID] = []
    private(set) var removeCount = 0

    init(sessionID: UUID? = nil) {
        self.sessionID = sessionID
    }

    func save(sessionID: UUID) {
        savedSessionIDs.append(sessionID)
        self.sessionID = sessionID
    }

    func removeSessionID() {
        removeCount += 1
        sessionID = nil
    }

}
