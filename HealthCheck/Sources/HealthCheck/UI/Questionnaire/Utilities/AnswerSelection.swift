import Foundation

struct AnswerSelection {

    private(set) var selectedAnswerID: String?
    private(set) var selectedAnswerIDs: Set<String> = []
    private(set) var numberText = ""

    private var number: Double? {
        try? Double(numberText, format: .number, lenient: false)
    }

    func isComplete(for question: Question) -> Bool {
        switch question.answer {
        case .singleChoice:
            return selectedAnswerID != nil || !question.isRequired
        case .multipleChoice(_, let selectionRange):
            return selectionRange.contains(selectedAnswerIDs.count)
        case .number(let valueRange):
            guard !numberText.isEmpty else { return !question.isRequired }

            return number.map { valueRange.contains($0) } ?? false
        }
    }

    func isNumberOutOfRange(for question: Question) -> Bool {
        guard
            case .number(let valueRange) = question.answer,
            let number
        else { return false }

        return !valueRange.contains(number)
    }

    mutating func select(answerID: String) {
        selectedAnswerID = answerID
    }

    mutating func toggle(answerID: String, in question: Question) {
        guard !selectedAnswerIDs.contains(answerID) else {
            selectedAnswerIDs.remove(answerID)
            return
        }
        guard
            case .multipleChoice(_, let selectionRange) = question.answer,
            selectedAnswerIDs.count < selectionRange.upperBound
        else { return }

        selectedAnswerIDs.insert(answerID)
    }

    mutating func enter(numberText: String) {
        self.numberText = numberText
    }

}
