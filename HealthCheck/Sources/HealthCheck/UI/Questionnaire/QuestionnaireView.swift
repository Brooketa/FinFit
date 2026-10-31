import SwiftUI
import FactoryKit
import CoreUI

public struct QuestionnaireView: View {

    @InjectedObservable private var presenter: QuestionnairePresenter

    @FocusState private var isTextInputFocused: Bool

    public init(sessionID: UUID) {
        _presenter = InjectedObservable(Container.shared.questionnairePresenter(sessionID))
    }

    public var body: some View {
        content
            .animation(.smooth(duration: Constants.transitionDuration), value: presenter.questionID)
            .background(Palette.background)
            .backButton(action: presenter.onBackTapped)
            .leaveConfirmationAlert(
                isPresented: $presenter.shouldPresentLeaveConfirmation,
                action: presenter.onLeaveConfirmationAction)
            .task {
                await presenter.startOrResumeSession()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle, .loading:
            ProgressView()
                .tint(Palette.primary)
                .alignCenter()
                .transition(.opacity)
        case .error:
            SessionUnavailable(action: presenter.onSessionUnavailableAction)
                .transition(.opacity)
        case .loaded(let question):
            loadedContent(for: question)
                .transition(.opacity)
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
            .slideTransition(id: question.id)
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
        case .multipleChoice(let options, let selectionRange):
            MultiSelectGroup(
                options: options.map { MultiSelectGroup.Option(id: $0.id, title: $0.title) },
                selection: presenter.answerSelection.selectedAnswerIDs,
                maximumSelection: selectionRange.upperBound,
                onToggle: presenter.onMultipleChoiceAnswerToggled(answerID:))
        case .number:
            TextInput(
                text: presenter.numberAnswerText,
                placeholder: .questionnaireNumberPlaceholder,
                label: answer.rangeInstruction,
                status: presenter.numberAnswerStatus,
                isFocused: $isTextInputFocused)
            .keyboardType(.decimalPad)
        }
    }

    private var footer: some View {
        ActionButton(
            title: .questionnaireNextButton,
            style: .primary,
            trailingIcon: Image(.arrowRight),
            isLoading: presenter.isSubmitting) {
            removeTextInputFocus()
            Task {
                await presenter.onNextTapped()
            }
        }
        .enabled(presenter.isNextEnabled)
        .padding(.horizontal, .extraLarge2)
        .padding(.top, .large)
    }

    private func removeTextInputFocus() {
        isTextInputFocused = false
    }

}

private extension QuestionnaireView {

    enum Constants {

        static let transitionDuration = 0.35

    }

}

#Preview {
    NavigationStack {
        QuestionnaireView(sessionID: UUID())
    }
}
