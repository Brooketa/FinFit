import SwiftUI

public struct ProgressBar: View {

    private let progress: Double

    /// A full-width rectangular bar filled to `progress`, from `0` (empty) to `1` (full). Values outside that range
    /// are clamped. The fill animates whenever `progress` changes.
    public init(progress: Double) {
        self.progress = progress
    }

    public var body: some View {
        Rectangle()
            .fill(Palette.border)
            .overlay(alignment: .leading) {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(Palette.primary)
                        .frame(width: geometry.size.width * fraction)
                }
            }
            .frame(height: Constants.height)
            .animation(.smooth, value: fraction)
    }

    private var fraction: CGFloat {
        min(max(progress, 0), 1)
    }

}

private extension ProgressBar {

    enum Constants {

        static let height: CGFloat = 4

    }

}

#Preview {
    @Previewable @State var progress = 0.2

    VStack(spacing: Spacing.extraLarge2.value) {
        ProgressBar(progress: 0)
        ProgressBar(progress: 0.2)
        ProgressBar(progress: 0.6)
        ProgressBar(progress: 1)
        ProgressBar(progress: 1.4)
        ProgressBar(progress: -0.5)

        ProgressBar(progress: progress)

        ActionButton(title: "Next step", style: .primary) {
            progress = progress >= 1 ? 0.2 : progress + 0.2
        }
    }
    .padding(.extraLarge2)
    .background(Palette.background)
}
