@MainActor
public protocol HealthCheckRoutingProtocol: AnyObject {

    func navigateToQuestionnaire()
    func navigateToResult(_ result: HealthCheckResult)

}
