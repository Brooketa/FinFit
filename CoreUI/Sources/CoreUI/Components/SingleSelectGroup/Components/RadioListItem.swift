import SwiftUI

public struct RadioListItem: View {

    private let title: String
    private let isSelected: Bool
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    /// A full-width option row showing `title` beside a radio indicator, highlighted when `isSelected`, that runs
    /// `action` when tapped anywhere on the row. Dims to half opacity when disabled with `.disabled(_:)`.
    public init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.medium.value) {
                indicator
                    .frame(width: Constants.indicatorSize, height: Constants.indicatorSize)

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
    private var indicator: some View {
        if isSelected {
            Circle()
                .fill(Palette.selected)
                .overlay {
                    Circle()
                        .fill(Palette.background)
                        .frame(width: Constants.dotSize, height: Constants.dotSize)
                }
        } else {
            Circle()
                .strokeBorder(Palette.border, lineWidth: Constants.ringWidth)
        }
    }

    private var fill: Color {
        isSelected ? Palette.selectedSubtle : Palette.background
    }

    private var outline: Color {
        isSelected ? Palette.selected : Palette.border
    }

    private var outlineWidth: CGFloat {
        isSelected ? Constants.selectedOutlineWidth : Constants.outlineWidth
    }

}

private extension RadioListItem {

    enum Constants {

        static let minimumHeight: CGFloat = 64
        static let outlineWidth: CGFloat = 1
        static let selectedOutlineWidth: CGFloat = 2
        static let indicatorSize: CGFloat = 24
        static let dotSize: CGFloat = 10
        static let ringWidth: CGFloat = 2
        static let disabledOpacity = 0.5

    }

}

#Preview {
    @Previewable @State var isFirstSelected = true
    @Previewable @State var isSecondSelected = false
    @Previewable @State var isDisabledSelected = false

    VStack(spacing: Spacing.medium.value) {
        RadioListItem(title: "Tap to toggle", isSelected: isFirstSelected) {
            isFirstSelected.toggle()
        }

        RadioListItem(title: "Tap to toggle", isSelected: isSecondSelected) {
            isSecondSelected.toggle()
        }

        RadioListItem(title: "Disabled, ignores taps", isSelected: isDisabledSelected) {
            isDisabledSelected.toggle()
        }
        .disabled(true)
    }
    .padding(.extraLarge2)
    .background(Palette.background)
}
