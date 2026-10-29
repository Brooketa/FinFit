import SwiftUI
import CoreUI

struct Logo: View {

    var body: some View {
        Circle()
            .fill(Palette.primarySubtle)
            .frame(width: Constants.haloSize, height: Constants.haloSize)
            .overlay {
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
                        Image(.introLogoSymbol)
                            .foregroundStyle(Palette.textOnDark)
                    }
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

    }

}

#Preview {
    Logo()
}
