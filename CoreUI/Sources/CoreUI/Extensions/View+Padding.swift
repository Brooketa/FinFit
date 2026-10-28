import SwiftUI

public extension View {

    /// Pads every edge of the view by `spacing`.
    func padding(_ spacing: Spacing) -> some View {
        padding(spacing.value)
    }

    /// Pads the given edges of the view by `spacing`.
    func padding(_ edges: Edge.Set, _ spacing: Spacing) -> some View {
        padding(edges, spacing.value)
    }

}
