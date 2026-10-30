import Foundation
import Testing
@testable import HealthCheck

@Suite("UserDefaultsSessionStore")
final class UserDefaultsSessionStoreTests {

    private let userDefaultsServiceMock = UserDefaultsServiceMock()
    private let sessionStore: UserDefaultsSessionStore

    init() {
        sessionStore = UserDefaultsSessionStore(userDefaultsService: userDefaultsServiceMock)
    }

    @Test("A saved session id is read back as the same id, under the store's key")
    func savedSessionIDReadsBack() {
        let sessionID = UUID()

        sessionStore.save(sessionID: sessionID)

        #expect(sessionStore.sessionID == sessionID)
        #expect(userDefaultsServiceMock.writtenKeys == [Constants.sessionIDKey])
    }

    @Test("With nothing saved, the session id is nil")
    func nothingSavedReadsAsNil() {
        #expect(sessionStore.sessionID == nil)
    }

    @Test("Removing the session id removes it from the underlying service")
    func removingSessionIDRemovesIt() {
        sessionStore.save(sessionID: UUID())

        sessionStore.removeSessionID()

        #expect(sessionStore.sessionID == nil)
        #expect(userDefaultsServiceMock.removedKeys == [Constants.sessionIDKey])
    }

    @Test("A failure while reading reads as nil")
    func readFailureReadsAsNil() {
        sessionStore.save(sessionID: UUID())
        userDefaultsServiceMock.readError = TestError.fixture()

        #expect(sessionStore.sessionID == nil)
    }

    @Test("A failure while saving doesn't throw or crash, and saves nothing")
    func saveFailureIsIgnored() {
        userDefaultsServiceMock.writeError = TestError.fixture()

        sessionStore.save(sessionID: UUID())

        #expect(userDefaultsServiceMock.writtenKeys.isEmpty)
        #expect(sessionStore.sessionID == nil)
    }

}

private extension UserDefaultsSessionStoreTests {

    enum Constants {

        static let sessionIDKey = "healthCheckSessionID"

    }

}
