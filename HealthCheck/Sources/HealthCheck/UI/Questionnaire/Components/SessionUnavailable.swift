import SwiftUI
import CoreUI

struct SessionUnavailable: View {

    let action: (Action) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.value) {
            Text(.questionnaireErrorTitle)
                .textStyle(.headingLarge)
                .foregroundStyle(Palette.textPrimary)

            Text(.questionnaireErrorMessage)
                .textStyle(.bodyMedium)
                .foregroundStyle(Palette.textSecondary)
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge2)
        .alignTopLeading()
        .safeAreaInset(edge: .bottom) {
            footer
        }
    }

    private var footer: some View {
        VStack(spacing: Spacing.medium.value) {
            ActionButton(title: .questionnaireErrorTryAgainButton, style: .primary) {
                action(.tryAgain)
            }

            ActionButton(title: .questionnaireErrorStartNewSessionButton, style: .secondary) {
                action(.startNewSession)
            }
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

}

extension SessionUnavailable {

    enum Action {

        case tryAgain
        case startNewSession

    }

}

#Preview {
    SessionUnavailable { _ in }
        .background(Palette.background)
}
