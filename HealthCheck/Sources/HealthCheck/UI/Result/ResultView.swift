import SwiftUI
import FactoryKit
import CoreUI

public struct ResultView: View {

    @InjectedObservable(\.resultPresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: Spacing.extraLarge3.value) {
            CircularProgressBar(progress: presenter.model.progress)

            summary
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .extraLarge2)
        .alignTop()
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Palette.background)
    }

    private var summary: some View {
        VStack(spacing: Spacing.medium.value) {
            Text(presenter.model.category.title)
                .textStyle(.headingLarge)
                .foregroundStyle(Palette.textPrimary)

            Text(presenter.model.category.subtitle)
                .textStyle(.bodyMedium)
                .foregroundStyle(Palette.textSecondary)
        }
        .multilineTextAlignment(.center)
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
        let category: ResultCategory

    }

}

extension ResultView.Model {

    init(for score: Int) {
        let progress = Double(score) / Constants.maximumScore
        let category = ResultCategory(for: score)

        self.init(progress: progress, category: category)
    }

}

private extension ResultView.Model {

    enum Constants {

        static let maximumScore: Double = 100

    }

}

#Preview {
    ResultView()
}
