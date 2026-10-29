import SwiftUI

public struct TextInput: View {

    private let placeholder: LocalizedStringResource
    private let label: LocalizedStringResource?
    private let prefix: String?
    private let status: Status

    @Binding private var text: String

    @FocusState private var isFocused: Bool

    @Environment(\.isEnabled) private var isEnabled

    /// A full-width text field editing `text`, showing `placeholder` while empty. An optional `label` sits above
    /// the field and an optional `prefix` before the text. An `.error` `status` outlines the field in the error color
    /// and shows its message below it. Takes `.keyboardType(_:)`, `.textContentType(_:)` and `.disabled(_:)` like a
    /// system text field.
    public init(
        text: Binding<String>,
        placeholder: LocalizedStringResource,
        label: LocalizedStringResource? = nil,
        prefix: String? = nil,
        status: Status = .normal
    ) {
        _text = text
        self.placeholder = placeholder
        self.label = label
        self.prefix = prefix
        self.status = status
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall.value) {
            if let label {
                Text(label)
                    .textStyle(.bodySmallMedium)
                    .foregroundStyle(Palette.textPrimary)
                    .accessibilityHidden(true)
            }

            field

            if case .error(let message) = status {
                Text(message)
                    .textStyle(.bodySmall)
                    .foregroundStyle(Palette.error)
            }
        }
        .compositingGroup()
        .opacity(isEnabled ? 1 : Constants.disabledOpacity)
    }

    private var field: some View {
        HStack(spacing: Spacing.small.value) {
            if let prefix {
                Text(prefix)
                    .textStyle(.bodyLargeMedium)
                    .foregroundStyle(Palette.textSecondary)
            }

            TextField(text: $text, prompt: prompt) {
                Text(label ?? placeholder)
            }
            .textStyle(.bodyLarge)
            .foregroundStyle(Palette.textPrimary)
            .tint(Palette.primary)
            .focused($isFocused)
        }
        .padding(.horizontal, .large)
        .frame(minHeight: Constants.minimumHeight)
        .background(Palette.background, in: .rect(cornerRadius: CornerRadius.large))
        .overlay {
            RoundedRectangle(cornerRadius: CornerRadius.large)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        }
        .contentShape(.rect(cornerRadius: CornerRadius.large))
        .onTapGesture {
            isFocused = true
        }
    }

    private var prompt: Text {
        Text(placeholder)
            .foregroundStyle(Palette.textSecondary)
    }

    private var borderColor: Color {
        switch status {
        case .normal:
            isFocused ? Palette.primary : Palette.border
        case .error:
            Palette.error
        }
    }

    private var borderWidth: CGFloat {
        switch status {
        case .normal:
            isFocused ? Constants.highlightedBorderWidth : Constants.borderWidth
        case .error:
            Constants.highlightedBorderWidth
        }
    }

}

public extension TextInput {

    enum Status: Equatable, Sendable {

        /// The field draws its default border, or the focused border while it has focus.
        case normal

        /// The field draws the error border and shows `message` below it.
        case error(LocalizedStringResource)

    }

}

private extension TextInput {

    enum Constants {

        static let minimumHeight: CGFloat = 56
        static let borderWidth: CGFloat = 1
        static let highlightedBorderWidth: CGFloat = 2
        static let disabledOpacity = 0.5

    }

}

#Preview {
    @Previewable @State var name = ""
    @Previewable @State var amount = "1,250"
    @Previewable @State var email = ""
    @Previewable @State var age = "abc"

    ScrollView {
        VStack(spacing: Spacing.large.value) {
            TextInput(text: $name, placeholder: "Placeholder")

            TextInput(text: $amount, placeholder: "Amount", prefix: "£")
                .keyboardType(.decimalPad)

            TextInput(text: $email, placeholder: "you@example.com", label: "Email")
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)

            TextInput(text: $age, placeholder: "Age", label: "Age", status: .error("Enter a number"))
                .keyboardType(.numberPad)

            TextInput(text: $amount, placeholder: "Amount", label: "Disabled", prefix: "£")
                .disabled(true)
        }
        .padding(.extraLarge2)
    }
    .background(Palette.background)
}
