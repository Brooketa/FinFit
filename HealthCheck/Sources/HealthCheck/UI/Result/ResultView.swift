import SwiftUI
import FactoryKit
import CoreUI

public struct ResultView: View {

    @InjectedObservable(\.resultPresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.extraLarge3.value) {
            CircularProgressBar(progress: presenter.model.progress)

            VStack(spacing: Spacing.medium.value) {
                Text(presenter.model.title)
                    .textStyle(.headingLarge)
                    .foregroundStyle(Palette.textPrimary)

                Text(presenter.model.subtitle)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(Palette.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge2)
        .alignTop()
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Palette.background)
    }

    private var footer: some View {
        VStack(spacing: Spacing.medium.value) {
            ActionButton(title: .resultFinishButton, style: .primary) {
                presenter.onFinishTapped()
            }

            ActionButton(
                title: .resultRetakeButton,
                style: .secondary,
                leadingIcon: Image(.retake)) {
                presenter.onRetakeTapped()
            }
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

}

extension ResultView {

    struct Model {

        let progress: Double
        let title: LocalizedStringResource
        let subtitle: LocalizedStringResource

    }

}

#Preview {
    ResultView()
}
