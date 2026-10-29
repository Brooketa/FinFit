import FactoryKit

extension Container {

    // MARK: Presenters

    @MainActor
    public var introPresenter: Factory<IntroPresenter> {
        self { IntroPresenter() }
    }

    // MARK: Routing

    public var healthCheckRouting: Factory<(any HealthCheckRoutingProtocol)?> {
        promised()
    }

}
