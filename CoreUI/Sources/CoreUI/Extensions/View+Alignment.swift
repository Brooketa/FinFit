import SwiftUI

public extension View {

    /// Expands the view to fill the available width and pins it to the leading edge.
    func alignLeading() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Expands the view to fill the available width and pins it to the trailing edge.
    func alignTrailing() -> some View {
        frame(maxWidth: .infinity, alignment: .trailing)
    }

    /// Expands the view to fill the available width and centers it horizontally.
    func alignHorizontalCenter() -> some View {
        frame(maxWidth: .infinity, alignment: .center)
    }

    /// Expands the view to fill the available height and pins it to the top edge.
    func alignTop() -> some View {
        frame(maxHeight: .infinity, alignment: .top)
    }

    /// Expands the view to fill the available height and pins it to the bottom edge.
    func alignBottom() -> some View {
        frame(maxHeight: .infinity, alignment: .bottom)
    }

    /// Expands the view to fill the available height and centers it vertically.
    func alignVerticalCenter() -> some View {
        frame(maxHeight: .infinity, alignment: .center)
    }

    /// Expands the view to fill the available space and pins it to the top leading corner.
    func alignTopLeading() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    /// Expands the view to fill the available space and pins it to the top trailing corner.
    func alignTopTrailing() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    /// Expands the view to fill the available space and pins it to the bottom leading corner.
    func alignBottomLeading() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }

    /// Expands the view to fill the available space and pins it to the bottom trailing corner.
    func alignBottomTrailing() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }

    /// Expands the view to fill the available space and centers it on both axes.
    func alignCenter() -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

}
