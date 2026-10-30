struct ValueRangeCase: Sendable, CustomStringConvertible {

    let description: String
    let min: Double?
    let max: Double?
    let expectedRange: ClosedRange<Double>

}
