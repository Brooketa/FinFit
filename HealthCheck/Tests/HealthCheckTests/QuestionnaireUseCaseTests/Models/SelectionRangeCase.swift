struct SelectionRangeCase: Sendable, CustomStringConvertible {

    let description: String
    let required: Bool?
    let minSelections: Int?
    let maxSelections: Int?
    let optionCount: Int
    let expectedRange: ClosedRange<Int>

}
