import SwiftUI

public struct TextStyle: Sendable {

    /// Bold large title, for the top of a screen.
    public static let title = TextStyle(font: .system(.largeTitle, weight: .bold))

    /// Semibold headline, for section titles and button labels.
    public static let headline = TextStyle(font: .system(.headline, weight: .semibold))

    /// Regular body text.
    public static let body = TextStyle(font: .system(.body))

    let font: Font

    private init(font: Font) {
        self.font = font
    }

}
