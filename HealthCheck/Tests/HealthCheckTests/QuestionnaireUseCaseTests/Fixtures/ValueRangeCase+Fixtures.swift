extension ValueRangeCase {

    static let fixtures: [ValueRangeCase] = [
        ValueRangeCase(
            description: "minimum and maximum",
            min: 0,
            max: 36,
            expectedRange: 0...36),
        ValueRangeCase(
            description: "only a minimum: unbounded above",
            min: 0,
            max: nil,
            expectedRange: 0...(.infinity)),
        ValueRangeCase(
            description: "only a maximum: unbounded below",
            min: nil,
            max: 100,
            expectedRange: -(.infinity)...100),
        ValueRangeCase(
            description: "no limits: unbounded both ways",
            min: nil,
            max: nil,
            expectedRange: -(.infinity)...(.infinity)),
        ValueRangeCase(
            description: "maximum below minimum: raised to the minimum",
            min: 10,
            max: 5,
            expectedRange: 10...10)
    ]

}
