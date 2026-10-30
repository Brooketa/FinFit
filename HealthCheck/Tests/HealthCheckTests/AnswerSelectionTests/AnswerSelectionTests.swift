import Foundation
import Testing
@testable import HealthCheck

@Suite("AnswerSelection")
final class AnswerSelectionTests {

    private var answerSelection = AnswerSelection()

    @Test("A single-choice answer is incomplete until an option is selected")
    func singleChoiceStartsIncomplete() {
        #expect(!answerSelection.isComplete(for: Constants.singleChoiceQuestion))
        #expect(answerSelection.answer(for: Constants.singleChoiceQuestion) == nil)
    }

    @Test("Selecting an option completes a single-choice answer, and selecting another replaces it")
    func singleChoiceSelectionReplaces() {
        answerSelection.select(answerID: "option_1")
        answerSelection.select(answerID: "option_2")

        #expect(answerSelection.isComplete(for: Constants.singleChoiceQuestion))
        #expect(answerSelection.answer(for: Constants.singleChoiceQuestion) == .option("option_2"))
    }

    @Test("A multiple-choice answer is complete only when the number selected is within the range")
    func multipleChoiceCompletesWithinRange() {
        let question = Question.fixture(answer: .multipleChoice(options: .fixtures(count: 4), selectionRange: 2...3))

        answerSelection.toggle(answerID: "option_1", in: question)
        #expect(!answerSelection.isComplete(for: question))

        answerSelection.toggle(answerID: "option_2", in: question)
        #expect(answerSelection.isComplete(for: question))
    }

    @Test("An empty multiple-choice answer is incomplete even when the range allows none")
    func emptyMultipleChoiceIsIncomplete() {
        let question = Question.fixture(answer: .multipleChoice(options: .fixtures(count: 4), selectionRange: 0...4))

        #expect(!answerSelection.isComplete(for: question))
    }

    @Test("A multiple-choice answer is submitted in the question's option order")
    func multipleChoiceKeepsOptionOrder() {
        let question = Question.fixture(answer: .multipleChoice(options: .fixtures(count: 4), selectionRange: 1...4))

        answerSelection.toggle(answerID: "option_3", in: question)
        answerSelection.toggle(answerID: "option_1", in: question)
        answerSelection.toggle(answerID: "option_4", in: question)

        #expect(answerSelection.answer(for: question) == .options(["option_1", "option_3", "option_4"]))
    }

    @Test("Toggling a selected option unselects it")
    func togglingUnselects() {
        let question = Question.fixture(answer: .multipleChoice(options: .fixtures(count: 4), selectionRange: 1...4))

        answerSelection.toggle(answerID: "option_2", in: question)
        answerSelection.toggle(answerID: "option_2", in: question)

        #expect(answerSelection.selectedAnswerIDs.isEmpty)
    }

    @Test("Once the maximum is reached, further options can't be added, but selected ones can be removed")
    func maximumBlocksFurtherSelections() {
        let question = Question.fixture(answer: .multipleChoice(options: .fixtures(count: 4), selectionRange: 1...2))

        answerSelection.toggle(answerID: "option_1", in: question)
        answerSelection.toggle(answerID: "option_2", in: question)
        answerSelection.toggle(answerID: "option_3", in: question)
        #expect(answerSelection.selectedAnswerIDs == ["option_1", "option_2"])

        answerSelection.toggle(answerID: "option_1", in: question)
        answerSelection.toggle(answerID: "option_3", in: question)
        #expect(answerSelection.selectedAnswerIDs == ["option_2", "option_3"])
    }

    @Test("A number answer is complete only when the text is a number within the range")
    func numberCompletesWithinRange() {
        answerSelection.enter(numberText: "12")
        #expect(answerSelection.answer(for: Constants.numberQuestion) == .number(12))

        answerSelection.enter(numberText: "50")
        #expect(!answerSelection.isComplete(for: Constants.numberQuestion))

        answerSelection.enter(numberText: "")
        #expect(!answerSelection.isComplete(for: Constants.numberQuestion))
    }

    @Test("Text that isn't a number is incomplete but not reported as out of range")
    func nonNumberIsNotOutOfRange() {
        answerSelection.enter(numberText: "twelve")

        #expect(!answerSelection.isComplete(for: Constants.numberQuestion))
        #expect(!answerSelection.isNumberOutOfRange(for: Constants.numberQuestion))
    }

    @Test("A number outside the range is reported as out of range, one inside it isn't")
    func numberOutsideRangeIsReported() {
        answerSelection.enter(numberText: "37")
        #expect(answerSelection.isNumberOutOfRange(for: Constants.numberQuestion))

        answerSelection.enter(numberText: "36")
        #expect(!answerSelection.isNumberOutOfRange(for: Constants.numberQuestion))
    }

    @Test("Out of range is only reported for number questions")
    func outOfRangeOnlyForNumbers() {
        answerSelection.enter(numberText: "99")

        #expect(!answerSelection.isNumberOutOfRange(for: Constants.singleChoiceQuestion))
    }

}

private extension AnswerSelectionTests {

    enum Constants {

        static let singleChoiceQuestion = Question.fixture(answer: .singleChoice(options: .fixtures(count: 3)))
        static let numberQuestion = Question.fixture(answer: .number(valueRange: 0...36))

    }

}
