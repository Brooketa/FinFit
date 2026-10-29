import SwiftUI

public struct SingleSelectGroup<ID: Hashable>: View {

    private let options: [Option]
    private let selection: ID?
    private let onSelect: (ID) -> Void

    /// A list of `options` stacked 12pt apart, where the option whose id matches `selection` is shown selected.
    /// Tapping an option calls `onSelect` with its id; the caller updates `selection`, so a new choice replaces
    /// the previous one. A `nil` `selection` shows every option unselected.
    public init(options: [Option], selection: ID?, onSelect: @escaping (ID) -> Void) {
        self.options = options
        self.selection = selection
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: Spacing.medium.value) {
            ForEach(options) { option in
                RadioListItem(title: option.title, isSelected: option.id == selection) {
                    onSelect(option.id)
                }
            }
        }
    }

}

public extension SingleSelectGroup {

    struct Option: Identifiable {

        /// The value handed to `onSelect` when this option is tapped.
        public let id: ID

        /// The text shown on the option's row.
        public let title: String

        /// An option identified by `id`, showing `title`.
        public init(id: ID, title: String) {
            self.id = id
            self.title = title
        }

    }

}

#Preview {
    @Previewable @State var selection: Int?

    VStack(spacing: Spacing.extraLarge3.value) {
        SingleSelectGroup(
            options: [
                SingleSelectGroup.Option(id: 1, title: "Very predictable"),
                SingleSelectGroup.Option(id: 2, title: "Mostly predictable"),
                SingleSelectGroup.Option(id: 3, title: "It varies significantly"),
                SingleSelectGroup.Option(id: 4, title: "Very unpredictable")
            ],
            selection: selection) { id in
                selection = id
            }

        SingleSelectGroup(
            options: [
                SingleSelectGroup.Option(id: 1, title: "Disabled, selected"),
                SingleSelectGroup.Option(id: 2, title: "Disabled")
            ],
            selection: 1) { _ in }
            .disabled(true)
    }
    .padding(.extraLarge2)
    .background(Palette.background)
}
