import SwiftUI
import FactoryKit
import CoreUI

public struct ResultView: View {

    @InjectedObservable private var presenter: ResultPresenter

    @State private var hasAppeared = false

    public init(result: HealthCheckResult) {
        _presenter = InjectedObservable(Container.shared.resultPresenter(result))
    }

    public var body: some View {
        VStack(spacing: Spacing.extraLarge3.value) {
            CircularProgressBar(progress: hasAppeared ? presenter.summary.progress : 0)

            summary
        }
        .onAppear {
            withAnimation(.easeInOut(duration: Constants.progressAnimationDuration)) {
                hasAppeared = true
            }
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge2)
        .alignTop()
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Palette.background)
        .navigationBarBackButtonHidden()
    }

    private var summary: some View {
        VStack(spacing: Spacing.medium.value) {
            Text(presenter.summary.title)
                .textStyle(.headingLarge)
                .foregroundStyle(Palette.textPrimary)

            Text(presenter.summary.subtitle)
                .textStyle(.bodyMedium)
                .foregroundStyle(Palette.textSecondary)
        }
        .multilineTextAlignment(.center)
        .animation(
            .easeOut(duration: Constants.summaryAnimationDuration)
                .delay(Constants.summaryAnimationDelay)) { content in
            content
                .offset(y: hasAppeared ? 0 : Constants.summaryRise)
                .opacity(hasAppeared ? 1 : 0)
        }
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

private extension ResultView {

    enum Constants {

        static let progressAnimationDuration = 0.75
        static let summaryAnimationDuration = 0.5
        static let summaryAnimationDelay = 0.25
        static let summaryRise: CGFloat = 12

    }

}

#Preview {
    ResultView(result: HealthCheckResult(score: 78, category: .good))
}
