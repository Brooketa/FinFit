import Foundation

struct AnswerSelection {

    private(set) var selectedAnswerID: String?
    private(set) var selectedAnswerIDs: Set<String> = []
    private(set) var numberText = ""

    private var number: Double? {
        try? Double(numberText, format: .number, lenient: false)
    }

    func answer(for question: Question) -> AnswerUseCaseModel? {
        switch question.answer {
        case .singleChoice:
            return selectedAnswerID.map { .option($0) }
        case .multipleChoice(let options, let selectionRange):
            guard
                !selectedAnswerIDs.isEmpty,
                selectionRange.contains(selectedAnswerIDs.count)
            else { return nil }

            return .options(options.map(\.id).filter { selectedAnswerIDs.contains($0) })
        case .number(let valueRange):
            guard
                let number,
                valueRange.contains(number)
            else { return nil }

            return .number(number)
        }
    }

    func isComplete(for question: Question) -> Bool {
        answer(for: question) != nil
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
