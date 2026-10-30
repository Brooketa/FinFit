import SwiftUI
import FactoryKit
import CoreUI

public struct QuestionnaireView: View {

    @InjectedObservable(\.questionnairePresenter) private var presenter

    public init() {}

    public var body: some View {
        content
            .background(Palette.background)
            .task {
                await presenter.startOrResumeSession()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle, .loading, .error:
            ProgressView()
                .tint(Palette.primary)
                .alignCenter()
        case .loaded(let question):
            loadedContent(for: question)
        }
    }

    private func loadedContent(for question: Question) -> some View {
        VStack(spacing: 0) {
            ProgressBar(progress: question.progress)

            ScrollView {
                VStack(spacing: Spacing.extraLarge3.value) {
                    header(for: question)

                    answer(question.answer)
                }
                .padding(.horizontal, .extraLarge2)
                .padding(.vertical, .extraLarge2)
            }
        }
        .safeAreaInset(edge: .bottom) {
            footer
        }
    }

    private func header(for question: Question) -> some View {
        VStack(alignment: .leading, spacing: Spacing.medium.value) {
            Text(question.title)
                .textStyle(.headingSmall)
                .foregroundStyle(Palette.textPrimary)

            if let description = question.description {
                Text(description)
                    .textStyle(.bodyMedium)
                    .foregroundStyle(Palette.textSecondary)
            }
        }
        .alignLeading()
    }

    @ViewBuilder
    private func answer(_ answer: Question.Answer) -> some View {
        switch answer {
        case .singleChoice(let options):
            SingleSelectGroup(
                options: options.map { SingleSelectGroup.Option(id: $0.id, title: $0.title) },
                selection: presenter.answerSelection.selectedAnswerID,
                onSelect: presenter.onSingleChoiceAnswerSelected(answerID:))
        case .multipleChoice(let options, _):
            MultiSelectGroup(
                options: options.map { MultiSelectGroup.Option(id: $0.id, title: $0.title) },
                selection: presenter.answerSelection.selectedAnswerIDs,
                onToggle: presenter.onMultipleChoiceAnswerToggled(answerID:))
        case .number(let valueRange):
            TextInput(
                text: Binding(
                    get: { presenter.answerSelection.numberText },
                    set: presenter.onNumberAnswerChanged(text:)),
                placeholder: .questionnaireNumberPlaceholder,
                status: presenter.isNumberAnswerOutOfRange ? .error(rangeMessage(for: valueRange)) : .normal)
            .keyboardType(.decimalPad)
        }
    }

    private var footer: some View {
        ActionButton(
            title: .questionnaireNextButton,
            style: .primary,
            trailingIcon: Image(.arrowRight),
            isLoading: presenter.isSubmitting) {
            Task {
                await presenter.onNextTapped()
            }
        }
        .enabled(presenter.isNextEnabled)
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

    private func rangeMessage(for valueRange: ClosedRange<Double>) -> LocalizedStringResource {
        let minimum = valueRange.lowerBound.formatted()
        let maximum = valueRange.upperBound.formatted()

        switch (valueRange.lowerBound.isFinite, valueRange.upperBound.isFinite) {
        case (true, true):
            return .questionnaireNumberRangeError(minimum: minimum, maximum: maximum)
        case (true, false):
            return .questionnaireNumberMinimumError(minimum: minimum)
        default:
            return .questionnaireNumberMaximumError(maximum: maximum)
        }
    }

}

#Preview {
    NavigationStack {
        QuestionnaireView()
    }
}
