import Foundation
import Testing
@testable import HealthCheck

@MainActor
@Suite("ContinueSessionPresenter")
final class ContinueSessionPresenterTests {

    private let savedSessionID = UUID()
    private let routerSpy = HealthCheckRouterSpy()
    private let sessionStoreMock: SessionStoreMock
    private let continueSessionPresenter: ContinueSessionPresenter

    init() {
        sessionStoreMock = SessionStoreMock(sessionID: savedSessionID)
        continueSessionPresenter = ContinueSessionPresenter(
            sessionID: savedSessionID,
            sessionStore: sessionStoreMock,
            router: routerSpy)
    }

    @Test("Tapping Continue navigates to the questionnaire with the saved session id")
    func continueOpensSavedSession() {
        continueSessionPresenter.onContinueTapped()

        #expect(routerSpy.calls == [.questionnaire(sessionID: savedSessionID)])
        #expect(sessionStoreMock.removeCount == 0)
    }

    @Test("Tapping Start over removes the saved session and navigates to a new one")
    func startOverOpensNewSession() throws {
        continueSessionPresenter.onStartOverTapped()

        #expect(sessionStoreMock.removeCount == 1)
        #expect(sessionStoreMock.sessionID == nil)
        #expect(routerSpy.calls.count == 1)
        let sessionID = try #require(routerSpy.calls.first?.questionnaireSessionID)
        #expect(sessionID != savedSessionID)
    }

}
