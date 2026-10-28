import SwiftUI

public struct PrimaryButton: View {

    private let title: LocalizedStringResource
    private let action: () -> Void

    /// A full-width, primary-filled button showing `title` that runs `action` when tapped.
    public init(title: LocalizedStringResource, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.bodyLargeMedium)
                .alignHorizontalCenter()
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .tint(Palette.primary)
    }

}
