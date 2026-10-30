import Foundation
import Testing
@testable import HealthCheck

@Suite("Questionnaire client models")
final class ClientModelsTests {

    private let encoder = JSONEncoder()

    @Test("An in-progress single-choice session decodes from the API's response")
    func singleChoiceSessionDecodes() throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.singleChoiceSession)

        #expect(session.sessionId == UUID(uuidString: "59ED129D-0DAE-4E37-B7C3-40F560E86820"))
        #expect(session.status == .inProgress)
        #expect(session.question?.id == "investment_dependency")
        #expect(session.question?.type == .singleChoice)
        #expect(session.question?.options?.map(\.id) == ["high", "medium", "low"])
        #expect(session.question?.validation?.required == true)
        #expect(session.question?.description == nil)
        #expect(session.result == nil)
        #expect(session.progress.current == 1)
        #expect(session.progress.total == 5)
    }

    @Test("An in-progress multiple-choice session decodes a minimum without a maximum")
    func multipleChoiceSessionDecodes() throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.multipleChoiceSession)

        #expect(session.question?.type == .multipleChoice)
        #expect(session.question?.description == "Select all that apply.")
        #expect(session.question?.options?.count == 6)
        #expect(session.question?.validation?.minSelections == 1)
        #expect(session.question?.validation?.maxSelections == nil)
    }

    @Test("An in-progress number session decodes its range and has no options")
    func numberSessionDecodes() throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.numberSession)

        #expect(session.question?.type == .number)
        #expect(session.question?.options == nil)
        #expect(session.question?.validation?.min == 0)
        #expect(session.question?.validation?.max == 36)
    }

    @Test("A question without validation decodes with no validation")
    func questionWithoutValidationDecodes() throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.sessionWithoutValidation)

        #expect(session.question?.validation == nil)
    }

    @Test("A completed session decodes its result and has no question")
    func completedSessionDecodes() throws {
        let session = try SessionClientModel.fixture(json: JSONFixture.Name.completedSession)

        #expect(session.status == .completed)
        #expect(session.question == nil)
        #expect(session.result?.score == 12)
        #expect(session.result?.category == .poor)
        #expect(session.progress.current == 5)
    }

    @Test("A single option encodes as its id")
    func singleOptionEncodes() throws {
        #expect(try json(encoding: AnswerClientModel.option("unpredictable")) == "\"unpredictable\"")
    }

    @Test("Several options encode as an array of ids")
    func severalOptionsEncode() throws {
        #expect(try json(encoding: AnswerClientModel.options(["retirement", "home"])) == "[\"retirement\",\"home\"]")
    }

    @Test("A whole number encodes without a decimal point, a fraction with one")
    func numberEncodes() throws {
        #expect(try json(encoding: AnswerClientModel.number(18)) == "18")
        #expect(try json(encoding: AnswerClientModel.number(2.5)) == "2.5")
    }

    @Test("A submission encodes its question id and answer")
    func submissionEncodes() throws {
        let submission = SubmissionClientModel(questionId: "monthly_income", answer: .number(2500))
        let data = try encoder.encode(submission)
        let object = try #require(JSONSerialization.jsonObject(with: data) as? NSDictionary)

        #expect(object == ["questionId": "monthly_income", "answer": 2500])
    }

    private func json(encoding answer: AnswerClientModel) throws -> String {
        String(decoding: try encoder.encode(answer), as: UTF8.self)
    }

}
