import Observation

@MainActor
@Observable
public final class HomePresenter {

    private let counterStore: CounterStoreProtocol
    private let router: HomeRoutingProtocol

    private var count: Int

    init(counterStore: CounterStoreProtocol, router: HomeRoutingProtocol) {
        self.counterStore = counterStore
        self.router = router
        count = counterStore.count
    }

    var counterCard: CounterCard.Model {
        CounterCard.Model(value: count)
    }

    func onIncrementTapped() {
        saveCount(count + 1)
    }

    func onResetTapped() {
        saveCount(0)
    }

    func onAboutTapped() {
        router.navigateToAbout()
    }

}

private extension HomePresenter {

    func saveCount(_ newCount: Int) {
        count = newCount
        counterStore.save(count: newCount)
    }

}
