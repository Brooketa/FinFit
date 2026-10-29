import SwiftUI

public struct CheckboxListItem: View {

    private let title: String
    private let isChecked: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    /// A full-width option row showing `title` beside a checkbox, highlighted when `isChecked`, that runs `action`
    /// when tapped anywhere on the row. Dims to half opacity when disabled with `.disabled(_:)`.
    public init(title: String, isChecked: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isChecked = isChecked
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.medium.value) {
                checkbox
                    .frame(width: Constants.checkboxSize, height: Constants.checkboxSize)

                Text(title)
                    .textStyle(.bodyMediumMedium)
                    .foregroundStyle(Palette.textPrimary)
                    .multilineTextAlignment(.leading)
                    .alignLeading()
            }
            .padding(.horizontal, .extraLarge)
            .frame(minHeight: Constants.minimumHeight)
            .background(fill, in: .rect(cornerRadius: CornerRadius.large))
            .overlay {
                RoundedRectangle(cornerRadius: CornerRadius.large)
                    .strokeBorder(outline, lineWidth: outlineWidth)
            }
            .contentShape(.rect(cornerRadius: CornerRadius.large))
        }
        .buttonStyle(.plain)
        .compositingGroup()
        .opacity(isEnabled ? 1 : Constants.disabledOpacity)
    }

    @ViewBuilder
    private var checkbox: some View {
        if isChecked {
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .fill(Palette.selected)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.system(size: Constants.checkmarkSize, weight: .bold))
                        .foregroundStyle(Palette.background)
                }
        } else {
            RoundedRectangle(cornerRadius: CornerRadius.small)
                .strokeBorder(Palette.border, lineWidth: Constants.checkboxOutlineWidth)
        }
    }

    private var fill: Color {
        isChecked ? Palette.selectedSubtle : Palette.background
    }

    private var outline: Color {
        isChecked ? Palette.selected : Palette.border
    }

    private var outlineWidth: CGFloat {
        isChecked ? Constants.checkedOutlineWidth : Constants.outlineWidth
    }

}

private extension CheckboxListItem {

    enum Constants {

        static let minimumHeight: CGFloat = 64
        static let outlineWidth: CGFloat = 1
        static let checkedOutlineWidth: CGFloat = 2
        static let checkboxSize: CGFloat = 24
        static let checkboxOutlineWidth: CGFloat = 2
        static let checkmarkSize: CGFloat = 14
        static let disabledOpacity = 0.5

    }

}

#Preview {
    @Previewable @State var isFirstChecked = true
    @Previewable @State var isSecondChecked = false
    @Previewable @State var isDisabledChecked = true

    VStack(spacing: Spacing.medium.value) {
        CheckboxListItem(title: "Tap to toggle", isChecked: isFirstChecked) {
            isFirstChecked.toggle()
        }

        CheckboxListItem(title: "Tap to toggle", isChecked: isSecondChecked) {
            isSecondChecked.toggle()
        }

        CheckboxListItem(title: "Disabled, ignores taps", isChecked: isDisabledChecked) {
            isDisabledChecked.toggle()
        }
        .disabled(true)
    }
    .padding(.extraLarge2)
    .background(Palette.background)
}
