import CoreGraphics

public struct Spacing: Sendable {

    /// 4pt padding or spacing.
    public static let extraSmall = grid(1)

    /// 8pt padding or spacing.
    public static let small = grid(2)

    /// 12pt padding or spacing.
    public static let medium = grid(3)

    /// 16pt padding or spacing.
    public static let large = grid(4)

    /// 24pt padding or spacing.
    public static let extraLarge = grid(6)

    /// 32pt padding or spacing.
    public static let extraExtraLarge = grid(8)

    /// The spacing in points.
    public let value: CGFloat

    private init(value: CGFloat) {
        self.value = value
    }

}

private extension Spacing {

    enum Constants {

        static let base: CGFloat = 4

    }

    static func grid(_ multiplier: CGFloat) -> Spacing {
        Spacing(value: Constants.base * multiplier)
    }

}
