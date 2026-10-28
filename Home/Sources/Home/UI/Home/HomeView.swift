import SwiftUI
import FactoryKit
import CoreUI

public struct HomeView: View {

    @InjectedObservable(\.homePresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.extraLarge.value) {
            Text(.homeTitle)
                .textStyle(.title)
                .foregroundStyle(Palette.textPrimary)
                .alignLeading()

            CounterCard(model: presenter.counterCard, action: onCounterCardAction)

            PrimaryButton(title: .homeAboutButton, action: presenter.onAboutTapped)
        }
        .padding(.large)
        .alignTop()
        .background(Palette.backgroundPrimary)
    }

}

private extension HomeView {

    func onCounterCardAction(_ action: CounterCard.Action) {
        switch action {
        case .increment:
            presenter.onIncrementTapped()
        case .reset:
            presenter.onResetTapped()
        }
    }

}
