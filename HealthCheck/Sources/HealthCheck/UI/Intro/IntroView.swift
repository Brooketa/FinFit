import SwiftUI
import FactoryKit
import CoreUI

public struct IntroView: View {

    @InjectedObservable(\.introPresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.extraLarge4.value) {
            Logo()

            VStack(spacing: Spacing.medium.value) {
                Text(.introTitle)
                    .textStyle(.headingLarge)
                    .foregroundStyle(Palette.textPrimary)

                Text(.introSubtitle)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(Palette.textSecondary)
            }
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge4)
        .alignTop()
        .safeAreaInset(edge: .bottom) {
			footer
        }
        .background(Palette.background)
    }

	private var footer: some View {
		ActionButton(
			title: .introStartButton,
			style: .primary,
			trailingIcon: Image(.arrowRight)) {
			presenter.onStartTapped()
		}
		.padding(.horizontal, .extraLarge2)
		.padding(.top, .large)
	}

}

#Preview {
    IntroView()
}
