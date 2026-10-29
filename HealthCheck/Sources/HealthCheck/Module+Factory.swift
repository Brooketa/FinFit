import FactoryKit

extension Container {

    // MARK: Routing

    public var healthCheckRouting: Factory<(any HealthCheckRoutingProtocol)?> {
        promised()
    }

}
