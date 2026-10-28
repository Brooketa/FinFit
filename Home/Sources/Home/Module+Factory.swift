import Foundation
import FactoryKit

extension Container {

    // MARK: Presenters

    @MainActor
    public var homePresenter: Factory<HomePresenter> {
        self { HomePresenter(counterStore: self.counterStore, router: self.homeRouting()!) }
    }

    @MainActor
    public var aboutPresenter: Factory<AboutPresenter> {
        self { AboutPresenter(bundle: .main) }
    }

    // MARK: Routing

    public var homeRouting: Factory<(any HomeRoutingProtocol)?> {
        promised()
    }

    // MARK: Stores

    private var counterStore: any CounterStoreProtocol {
        self { UserDefaultsCounterStore(userDefaults: .standard) }.resolve()
    }

}
