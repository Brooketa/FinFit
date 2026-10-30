import SwiftUI

public extension View {

    /// Slides the view in from the trailing edge and the previous one out to the leading edge, both fading, whenever
    /// `id` changes, so the content is replaced in place like turning a page. The slide runs over 0.35s.
    func slideTransition(id: some Hashable) -> some View {
        ZStack {
            self
                .id(id)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)))
        }
        .animation(.smooth(duration: Constants.duration), value: id)
    }

}

private enum Constants {

    static let duration = 0.35

}
