import SwiftUI
import CoreUI

struct CircularProgressBar: View {

    let progress: Double

    var body: some View {
        ZStack {
            progressRing

            labels
        }
        .padding(Constants.lineWidth / 2)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: Constants.maximumSize, maxHeight: Constants.maximumSize)
    }

    private var progressRing: some View {
        ZStack {
            Circle()
                .stroke(Palette.primarySubtle, lineWidth: Constants.lineWidth)

            Circle()
                .trim(from: 0, to: fraction)
                .stroke(Palette.primary, lineWidth: Constants.lineWidth)
                .rotationEffect(.degrees(-90))
        }
    }

    private var labels: some View {
        VStack(spacing: Spacing.extraSmall.value) {
            Text(percentage, format: .number)
                .textStyle(.headingExtraLarge)
                .foregroundStyle(Palette.textPrimary)

            Text(.resultScoreMaximum)
                .textStyle(.bodyMedium)
                .foregroundStyle(Palette.textSecondary)
        }
    }

    private var fraction: CGFloat {
        min(max(progress, 0), 1)
    }

    private var percentage: Int {
        Int((fraction * 100).rounded())
    }

}

private extension CircularProgressBar {

    enum Constants {

        static let lineWidth: CGFloat = 20
        static let maximumSize: CGFloat = 240

    }

}

#Preview {
    CircularProgressBar(progress: 0.78)
        .padding(.extraLarge2)
        .background(Palette.background)
}
