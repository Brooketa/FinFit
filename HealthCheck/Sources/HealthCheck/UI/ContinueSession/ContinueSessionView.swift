import SwiftUI
import FactoryKit
import CoreUI

public struct ContinueSessionView: View {

    @InjectedObservable private var presenter: ContinueSessionPresenter

    public init(sessionID: UUID) {
        _presenter = InjectedObservable(Container.shared.continueSessionPresenter(sessionID))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.value) {
            Text(.continueSessionTitle)
                .textStyle(.headingLarge)
                .foregroundStyle(Palette.textPrimary)

            Text(.continueSessionSubtitle)
                .textStyle(.bodyMedium)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge2)
        .alignTopLeading()
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Palette.background)
    }

    private var footer: some View {
        VStack(spacing: Spacing.medium.value) {
            ActionButton(
                title: .continueSessionContinueButton,
                style: .primary,
                trailingIcon: Image(.arrowRight)) {
                presenter.onContinueTapped()
            }

            ActionButton(
                title: .continueSessionStartOverButton,
                style: .destructive,
                leadingIcon: Image(.retake)) {
                presenter.onStartOverTapped()
            }
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

}

#Preview {
    NavigationStack {
        ContinueSessionView(sessionID: UUID())
    }
}
