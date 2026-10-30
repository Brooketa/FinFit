import Foundation
import Testing
@testable import HealthCheck

@MainActor
@Suite("IntroPresenter")
final class IntroPresenterTests {

    private let routerSpy = HealthCheckRouterSpy()

    @Test("Tapping Start with no saved session navigates to the questionnaire with a new session id")
    func startWithoutSavedSessionOpensQuestionnaire() {
        let introPresenter = IntroPresenter(sessionStore: SessionStoreMock(), router: routerSpy)

        introPresenter.onStartTapped()

        #expect(routerSpy.calls.count == 1)
        #expect(routerSpy.calls.first?.questionnaireSessionID != nil)
    }

    @Test("Tapping Start with a saved session navigates to Continue session with that id")
    func startWithSavedSessionOpensContinueSession() {
        let savedSessionID = UUID()
        let sessionStoreMock = SessionStoreMock(sessionID: savedSessionID)
        let introPresenter = IntroPresenter(sessionStore: sessionStoreMock, router: routerSpy)

        introPresenter.onStartTapped()

        #expect(routerSpy.calls == [.continueSession(sessionID: savedSessionID)])
    }

    @Test("Each Start tap uses a fresh session id when nothing is saved")
    func startUsesFreshSessionIDs() {
        let introPresenter = IntroPresenter(sessionStore: SessionStoreMock(), router: routerSpy)

        introPresenter.onStartTapped()
        introPresenter.onStartTapped()

        #expect(routerSpy.calls.count == 2)
        #expect(routerSpy.calls.first != routerSpy.calls.last)
    }

}
