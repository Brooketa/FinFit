@MainActor
public protocol HealthCheckRoutingProtocol: AnyObject {

    func navigateToQuestionnaire()
    func navigateToResult(score: Int)

}
