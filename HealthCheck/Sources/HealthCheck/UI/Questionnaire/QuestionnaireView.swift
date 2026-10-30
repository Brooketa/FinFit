import SwiftUI
import FactoryKit
import CoreUI

public struct QuestionnaireView: View {

    @InjectedObservable(\.questionnairePresenter) private var presenter

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            ProgressBar(progress: presenter.model.progress)

            ScrollView {
                header
                    .padding(.horizontal, .extraLarge2)
                    .padding(.vertical, .extraLarge2)
            }
        }
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Palette.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Spacing.medium.value) {
            Text(presenter.model.title)
                .textStyle(.headingSmall)
                .foregroundStyle(Palette.textPrimary)

            if let description = presenter.model.description {
                Text(description)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
        .alignLeading()
    }

    private var footer: some View {
        ActionButton(
            title: .questionnaireNextButton,
            style: .primary,
            trailingIcon: Image(.arrowRight)) {
            presenter.onNextTapped()
        }
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

}

extension QuestionnaireView {

    struct Model {

        let progress: Double
        let title: String
        let description: String?

    }

}

#Preview {
    NavigationStack {
        QuestionnaireView()
    }
}
