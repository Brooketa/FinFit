import Foundation
import Testing
@testable import HealthCheck

@Suite("Question")
final class QuestionTests {

    @Test("Progress is the current question over the total")
    func progressIsCurrentOverTotal() {
        let question = Question(from: .fixture(), progress: .fixture(current: 2, total: 5))

        #expect(question.progress == 0.4)
    }

    @Test("A range with both bounds reads as between them")
    func bothBoundsReadAsBetween() {
        let answer = Question.Answer.number(valueRange: 0...36)

        #expect(answer.rangeInstruction == .questionnaireRangeNumberBetween(
            minimum: 0.0.formatted(),
            maximum: 36.0.formatted()))
    }

    @Test("A range with only a minimum reads as a minimum")
    func onlyMinimumReadsAsMinimum() {
        let answer = Question.Answer.number(valueRange: 10...(.infinity))

        #expect(answer.rangeInstruction == .questionnaireRangeNumberMinimum(minimum: 10.0.formatted()))
    }

    @Test("A range with only a maximum reads as a maximum")
    func onlyMaximumReadsAsMaximum() {
        let answer = Question.Answer.number(valueRange: -(.infinity)...100)

        #expect(answer.rangeInstruction == .questionnaireRangeNumberMaximum(maximum: 100.0.formatted()))
    }

    @Test("An unbounded range has no instruction")
    func unboundedRangeHasNoInstruction() {
        let answer = Question.Answer.number(valueRange: -(.infinity)...(.infinity))

        #expect(answer.rangeInstruction == nil)
    }

    @Test("A choice question has no range instruction")
    func choiceQuestionHasNoInstruction() {
        let singleChoice = Question.Answer.singleChoice(options: .fixtures(count: 2))
        let multipleChoice = Question.Answer.multipleChoice(options: .fixtures(count: 2), selectionRange: 1...2)

        #expect(singleChoice.rangeInstruction == nil)
        #expect(multipleChoice.rangeInstruction == nil)
    }

}
