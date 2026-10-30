extension SelectionRangeCase {

    static let fixtures: [SelectionRangeCase] = [
        SelectionRangeCase(
            description: "required, no limits: at least one, at most every option",
            required: true,
            minSelections: nil,
            maxSelections: nil,
            optionCount: 4,
            expectedRange: 1...4),
        SelectionRangeCase(
            description: "optional, no limits: none required, at most every option",
            required: false,
            minSelections: nil,
            maxSelections: nil,
            optionCount: 4,
            expectedRange: 0...4),
        SelectionRangeCase(
            description: "no required flag: treated as optional",
            required: nil,
            minSelections: nil,
            maxSelections: nil,
            optionCount: 3,
            expectedRange: 0...3),
        SelectionRangeCase(
            description: "both limits given: follows them",
            required: true,
            minSelections: 2,
            maxSelections: 3,
            optionCount: 6,
            expectedRange: 2...3),
        SelectionRangeCase(
            description: "only a maximum: required minimum of one",
            required: true,
            minSelections: nil,
            maxSelections: 3,
            optionCount: 6,
            expectedRange: 1...3),
        SelectionRangeCase(
            description: "maximum below minimum: raised to the minimum",
            required: true,
            minSelections: 3,
            maxSelections: 1,
            optionCount: 6,
            expectedRange: 3...3)
    ]

}
