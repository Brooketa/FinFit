import Foundation

@MainActor
public protocol HealthCheckRoutingProtocol: AnyObject {

    func navigateToIntro()
    func navigateToQuestionnaire(sessionID: UUID)
    func navigateBackToQuestionnaire()
    func navigateToResult(_ result: HealthCheckResult)

}
