import SwiftUI

struct ActionButtonStyle: ButtonStyle {

    let style: ActionButton.Style

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(style.content)
            .tint(style.content)
            .background(style.fill, in: .capsule)
            .overlay {
                Capsule()
                    .strokeBorder(style.outline, lineWidth: Constants.outlineWidth)
            }
            .contentShape(.capsule)
            .compositingGroup()
            .opacity(opacity(isPressed: configuration.isPressed))
    }

    private func opacity(isPressed: Bool) -> Double {
        guard isEnabled else { return Constants.disabledOpacity }

        return isPressed ? Constants.pressedOpacity : 1
    }

}

private extension ActionButtonStyle {

    enum Constants {

        static let outlineWidth: CGFloat = 1.5
        static let pressedOpacity = 0.8
        static let disabledOpacity = 0.5

    }

}

private extension ActionButton.Style {

    var fill: Color {
        switch self {
        case .primary:
            Palette.primary
        case .secondary:
            Palette.background
        case .destructive:
            Palette.error
        }
    }

    var outline: Color {
        switch self {
        case .primary, .secondary:
            Palette.primary
        case .destructive:
            Palette.error
        }
    }

    var content: Color {
        switch self {
        case .primary, .destructive:
            Palette.textOnPrimary
        case .secondary:
            Palette.primary
        }
    }

}
