import SwiftUI

public struct TextStyle: Sendable {

    /// Bold 48pt heading, tracking −2%.
    public static let headingExtraLarge = TextStyle(size: 48, weight: .bold, tracking: -0.02)

    /// Bold 36pt heading, tracking −1.5%.
    public static let headingLarge = TextStyle(size: 36, weight: .bold, tracking: -0.015)

    /// Bold 30pt heading, tracking −1%.
    public static let headingMedium = TextStyle(size: 30, weight: .bold, tracking: -0.01)

    /// Semibold 24pt heading, tracking −0.5%.
    public static let headingSmall = TextStyle(size: 24, weight: .semibold, tracking: -0.005)

    /// Semibold 20pt heading, tracking −0.3%.
    public static let headingExtraSmall = TextStyle(size: 20, weight: .semibold, tracking: -0.003)

    /// Regular 16pt body text.
    public static let bodyLarge = TextStyle(size: 16, weight: .regular, tracking: 0)

    /// Regular 14pt body text.
    public static let bodyMedium = TextStyle(size: 14, weight: .regular, tracking: 0)

    /// Regular 12pt body text.
    public static let bodySmall = TextStyle(size: 12, weight: .regular, tracking: 0)

    /// Medium 16pt body text, tracking +0.2%.
    public static let bodyLargeMedium = TextStyle(size: 16, weight: .medium, tracking: 0.002)

    /// Medium 14pt body text, tracking +0.2%.
    public static let bodyMediumMedium = TextStyle(size: 14, weight: .medium, tracking: 0.002)

    /// Medium 12pt body text, tracking +0.2%.
    public static let bodySmallMedium = TextStyle(size: 12, weight: .medium, tracking: 0.002)

    let font: Font
    let tracking: CGFloat

    private init(size: CGFloat, weight: Font.Weight, tracking: CGFloat) {
        font = .system(size: size, weight: weight)
        self.tracking = size * tracking
    }

}
