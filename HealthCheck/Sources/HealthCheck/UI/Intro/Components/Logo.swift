import SwiftUI
import CoreUI

struct Logo: View {

    @State private var hasAppeared = false

    var body: some View {
        ZStack {
            halo

            badge
        }
        .onAppear {
            hasAppeared = true
        }
    }

    private var halo: some View {
        Circle()
            .fill(Palette.primarySubtle)
            .frame(width: Constants.haloSize, height: Constants.haloSize)
            .animation(.easeInOut(duration: Constants.pulseDuration).repeatForever()) { content in
                content
                    .scaleEffect(hasAppeared ? Constants.haloPulseScale : 1)
                    .opacity(hasAppeared ? Constants.haloPulseOpacity : 1)
            }
    }

    private var badge: some View {
        Circle()
            .fill(LinearGradient(
                colors: [Palette.primary, Palette.darkBackground],
                startPoint: .leading,
                endPoint: .trailing))
            .frame(width: Constants.badgeSize, height: Constants.badgeSize)
            .shadow(
                color: Palette.darkBackground.opacity(Constants.shadowOpacity),
                radius: Constants.shadowRadius,
                y: Constants.shadowOffset)
            .overlay {
                symbol
            }
            .animation(.spring(duration: Constants.entranceDuration, bounce: Constants.entranceBounce)) { content in
                content
                    .scaleEffect(hasAppeared ? 1 : Constants.entranceScale)
            }
            .animation(
                .easeInOut(duration: Constants.pulseDuration)
                    .repeatForever()
                    .delay(Constants.badgePulseDelay)) { content in
                content
                    .scaleEffect(hasAppeared ? Constants.badgePulseScale : 1)
            }
    }

    private var symbol: some View {
        Image(.introLogoSymbol)
            .foregroundStyle(Palette.textOnDark)
            .animation(.easeOut(duration: Constants.entranceDuration).delay(Constants.symbolDelay)) { content in
                content
                    .offset(y: hasAppeared ? 0 : Constants.symbolRise)
                    .opacity(hasAppeared ? 1 : 0)
            }
    }

}

private extension Logo {

    enum Constants {

        static let haloSize: CGFloat = 180
        static let badgeSize: CGFloat = 120
        static let shadowOpacity = 0.25
        static let shadowRadius: CGFloat = 16
        static let shadowOffset: CGFloat = 12
        static let pulseDuration = 1.6
        static let haloPulseScale = 1.08
        static let haloPulseOpacity = 0.7
        static let badgePulseScale = 1.04
        static let badgePulseDelay = 0.4
        static let entranceScale = 0.6
        static let entranceDuration = 0.6
        static let entranceBounce = 0.35
        static let symbolDelay = 0.15
        static let symbolRise: CGFloat = 12

    }

}

#Preview {
    Logo()
}
