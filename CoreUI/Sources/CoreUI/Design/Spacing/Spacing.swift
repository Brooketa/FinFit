import CoreGraphics

public struct Spacing: Sendable {

    /// 4pt padding or spacing.
    public static let extraSmall = units(1)

    /// 8pt padding or spacing.
    public static let small = units(2)

    /// 12pt padding or spacing.
    public static let medium = units(3)

    /// 16pt padding or spacing.
    public static let large = units(4)

    /// 20pt padding or spacing.
    public static let extraLarge = units(5)

    /// 24pt padding or spacing.
    public static let extraLarge2 = units(6)

    /// 32pt padding or spacing.
    public static let extraLarge3 = units(8)

    /// 48pt padding or spacing.
    public static let extraLarge4 = units(12)

    /// 64pt padding or spacing.
    public static let extraLarge5 = units(16)

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

    static func units(_ count: CGFloat) -> Spacing {
        Spacing(value: Constants.base * count)
    }

}
