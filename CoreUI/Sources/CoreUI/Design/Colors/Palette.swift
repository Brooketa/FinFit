import SwiftUI

public enum Palette {

    /// The brand color: primary buttons, links, selection.
    public static let primary = Color(.primary)

    /// A light tint of the brand color, for subtle highlights behind brand content.
    public static let primarySubtle = Color(.primarySubtle)

    /// The screen background.
    public static let background = Color(.background)

    /// A background for grouped content sitting on the screen background.
    public static let backgroundSecondary = Color(.backgroundSecondary)

    /// A background one step stronger than `backgroundSecondary`.
    public static let backgroundTertiary = Color(.backgroundTertiary)

    /// The fill of cards, inputs and list items.
    public static let surface = Color(.surface)

    /// Titles and body text.
    public static let textPrimary = Color(.textPrimary)

    /// Supporting text: captions, hints, metadata.
    public static let textSecondary = Color(.textSecondary)

    /// De-emphasised text: placeholders and disabled labels.
    public static let textTertiary = Color(.textTertiary)

    /// Text drawn on a `primary` fill.
    public static let textOnPrimary = Color(.textOnPrimary)

    /// Text drawn on a `darkBackground` or `selected` fill.
    public static let textOnDark = Color(.textOnDark)

    /// Default outlines and dividers.
    public static let border = Color(.border)

    /// Outlines that need more contrast, such as unselected controls.
    public static let borderStrong = Color(.borderStrong)

    /// Icons at full emphasis.
    public static let iconPrimary = Color(.iconPrimary)

    /// Icons at reduced emphasis.
    public static let iconSecondary = Color(.iconSecondary)

    /// Positive outcomes and confirmations.
    public static let success = Color(.success)

    /// Cautions that need attention but are not failures.
    public static let warning = Color(.warning)

    /// Errors, validation failures and destructive actions.
    public static let error = Color(.error)

    /// Neutral information.
    public static let info = Color(.info)

    /// A dark fill for high-emphasis areas.
    public static let darkBackground = Color(.darkBackground)

    /// The fill of a selected item.
    public static let selected = Color(.selected)

    /// A light fill behind a selected item.
    public static let selectedSubtle = Color(.selectedSubtle)

}
