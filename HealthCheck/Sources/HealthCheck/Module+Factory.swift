import FactoryKit

extension Container {

    // MARK: Presenters

    @MainActor
    public var introPresenter: Factory<IntroPresenter> {
        self { IntroPresenter() }
    }

    @MainActor
    public var resultPresenter: Factory<ResultPresenter> {
        self { ResultPresenter() }
    }

    // MARK: Routing

    public var healthCheckRouting: Factory<(any HealthCheckRoutingProtocol)?> {
        promised()
    }

}
