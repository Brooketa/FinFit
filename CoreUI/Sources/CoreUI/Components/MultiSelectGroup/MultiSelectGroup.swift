import SwiftUI

public struct MultiSelectGroup<ID: Hashable>: View {

    private let options: [Option]
    private let selection: Set<ID>
    private let maximumSelection: Int?
    private let onToggle: (ID) -> Void

    /// A list of `options` stacked 12pt apart, where every option whose id is in `selection` is shown checked.
    /// Tapping an option calls `onToggle` with its id; the caller adds it to or removes it from `selection`, so each
    /// option toggles on its own. Once `selection` holds `maximumSelection` options, the unchecked ones are disabled.
    public init(
        options: [Option],
        selection: Set<ID>,
        maximumSelection: Int? = nil,
        onToggle: @escaping (ID) -> Void
    ) {
        self.options = options
        self.selection = selection
        self.maximumSelection = maximumSelection
        self.onToggle = onToggle
    }

    public var body: some View {
        VStack(spacing: Spacing.medium.value) {
            ForEach(options) { option in
                let isChecked = selection.contains(option.id)

                CheckboxListItem(title: option.title, isChecked: isChecked) {
                    onToggle(option.id)
                }
                .disabled(isLimitReached && !isChecked)
            }
        }
    }

    private var isLimitReached: Bool {
        guard let maximumSelection else { return false }

        return selection.count >= maximumSelection
    }

}

public extension MultiSelectGroup {

    struct Option: Identifiable {

        /// The value handed to `onToggle` when this option is tapped.
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
    @Previewable @State var selection: Set<Int> = [1]

    VStack(spacing: Spacing.extraLarge3.value) {
        MultiSelectGroup(
            options: [
                MultiSelectGroup.Option(id: 1, title: "Lifetime ISA"),
                MultiSelectGroup.Option(id: 2, title: "General Investment Account"),
                MultiSelectGroup.Option(id: 3, title: "Junior ISA")
            ],
            selection: selection) { id in
                if selection.contains(id) {
                    selection.remove(id)
                } else {
                    selection.insert(id)
                }
            }

        MultiSelectGroup(
            options: [
                MultiSelectGroup.Option(id: 1, title: "Checked"),
                MultiSelectGroup.Option(id: 2, title: "Checked"),
                MultiSelectGroup.Option(id: 3, title: "Disabled at the limit")
            ],
            selection: [1, 2],
            maximumSelection: 2) { _ in }

        MultiSelectGroup(
            options: [
                MultiSelectGroup.Option(id: 1, title: "Disabled, checked"),
                MultiSelectGroup.Option(id: 2, title: "Disabled")
            ],
            selection: [1]) { _ in }
            .disabled(true)
    }
    .padding(.extraLarge2)
    .background(Palette.background)
}
