import SwiftUI

public struct ActionButton: View {

    private let title: LocalizedStringResource
    private let style: Style
    private let leadingIcon: Image?
    private let trailingIcon: Image?
    private let isLoading: Bool
    private let action: () -> Void

    /// A full-width, capsule-shaped button showing `title` between optional icons, colored by `style`,
    /// that runs `action` when tapped. Dims to half opacity when disabled with `.disabled(_:)`. While `isLoading`,
    /// a spinner replaces the title and icons, the button keeps its size and taps are ignored.
    public init(
        title: LocalizedStringResource,
        style: Style,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            label
                .opacity(isLoading ? 0 : 1)
                .overlay {
                    if isLoading {
                        ProgressView()
                    }
                }
                .padding(.horizontal, .extraLarge3)
                .frame(maxWidth: .infinity, minHeight: Constants.minimumHeight)
        }
        .buttonStyle(ActionButtonStyle(style: style))
        .allowsHitTesting(!isLoading)
    }

    private var label: some View {
        HStack(spacing: Spacing.small.value) {
            if let leadingIcon {
                icon(leadingIcon)
            }

            Text(title)
                .textStyle(.bodyMediumMedium)
                .multilineTextAlignment(.center)

            if let trailingIcon {
                icon(trailingIcon)
            }
        }
    }

    private func icon(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: Constants.iconSize, height: Constants.iconSize)
            .accessibilityHidden(true)
    }

}

public extension ActionButton {

    enum Style: Sendable {

        /// A `primary` fill with `textOnPrimary` content, for the main action on a screen.
        case primary

        /// A `background` fill with a `primary` outline and content, for an alternative action.
        case secondary

        /// An `error` fill with `textOnPrimary` content, for an action that deletes or cannot be undone.
        case destructive

    }

}

private extension ActionButton {

    enum Constants {

        static let minimumHeight: CGFloat = 60
        static let iconSize: CGFloat = 24

    }

}
