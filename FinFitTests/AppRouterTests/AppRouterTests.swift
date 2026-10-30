import Foundation
import Testing
@testable import FinFit
@testable import HealthCheck

@MainActor
@Suite("AppRouter")
final class AppRouterTests {

    private let appRouter = AppRouter()

    @Test("Navigating to Continue session pushes it with its session id")
    func continueSessionIsPushed() {
        let sessionID = UUID()

        appRouter.navigateToContinueSession(sessionID: sessionID)

        #expect(appRouter.path == [.continueSession(sessionID: sessionID)])
    }

    @Test("Navigating to the questionnaire pushes it with its session id, on top of what is there")
    func questionnaireIsPushed() {
        let savedSessionID = UUID()
        let sessionID = UUID()
        appRouter.navigateToContinueSession(sessionID: savedSessionID)

        appRouter.navigateToQuestionnaire(sessionID: sessionID)

        #expect(appRouter.path == [.continueSession(sessionID: savedSessionID), .questionnaire(sessionID: sessionID)])
    }

    @Test("Navigating to the result pushes it with its result")
    func resultIsPushed() {
        let sessionID = UUID()
        appRouter.navigateToQuestionnaire(sessionID: sessionID)

        appRouter.navigateToResult(.fixture(score: 64, category: .fair))

        #expect(appRouter.path == [
            .questionnaire(sessionID: sessionID),
            .result(.fixture(score: 64, category: .fair))
        ])
    }

    @Test("Navigating to the intro empties the path from any depth")
    func introEmptiesPath() {
        appRouter.navigateToContinueSession(sessionID: UUID())
        appRouter.navigateToQuestionnaire(sessionID: UUID())
        appRouter.navigateToResult(.fixture())

        appRouter.navigateToIntro()

        #expect(appRouter.path.isEmpty)
    }

    @Test("Navigating back to the questionnaire pops everything above the last questionnaire and keeps it")
    func backToQuestionnairePopsAboveIt() {
        let savedSessionID = UUID()
        let firstSessionID = UUID()
        let secondSessionID = UUID()
        appRouter.navigateToContinueSession(sessionID: savedSessionID)
        appRouter.navigateToQuestionnaire(sessionID: firstSessionID)
        appRouter.navigateToResult(.fixture())
        appRouter.navigateToQuestionnaire(sessionID: secondSessionID)
        appRouter.navigateToResult(.fixture(score: 40, category: .poor))

        appRouter.navigateBackToQuestionnaire()

        #expect(appRouter.path == [
            .continueSession(sessionID: savedSessionID),
            .questionnaire(sessionID: firstSessionID),
            .result(.fixture()),
            .questionnaire(sessionID: secondSessionID)
        ])
    }

    @Test("Navigating back to the questionnaire with none on the path leaves the path unchanged")
    func backToQuestionnaireWithoutOneDoesNothing() {
        let sessionID = UUID()
        appRouter.navigateToContinueSession(sessionID: sessionID)

        appRouter.navigateBackToQuestionnaire()

        #expect(appRouter.path == [.continueSession(sessionID: sessionID)])
    }

}
