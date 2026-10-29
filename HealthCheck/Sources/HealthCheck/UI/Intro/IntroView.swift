import SwiftUI
import FactoryKit
import CoreUI

public struct IntroView: View {

    @InjectedObservable(\.introPresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.extraLarge3.value) {
            Text(.introTitle)
                .textStyle(.headingLarge)
                .foregroundStyle(Palette.textPrimary)
                .multilineTextAlignment(.center)
                .alignCenter()

            ActionButton(title: .introStartButton, style: .primary) {
                presenter.onStartTapped()
            }
        }
        .padding(.extraLarge2)
        .background(Palette.background)
    }

}

#Preview {
    IntroView()
}
