import Foundation
import Testing
@testable import HealthCheck

@Suite("Questionnaire client models")
final class ClientModelsTests {

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    @Test("An in-progress single-choice session decodes from API JSON")
    func singleChoiceSessionDecodes() throws {
        let session = try decoder.decode(SessionClientModel.self, from: SessionJSON.singleChoiceInProgress)

        #expect(session.sessionId == UUID(uuidString: "9CF3DC4B-7E4E-4073-BD4C-12AADFDF4930"))
        #expect(session.status == .inProgress)
        #expect(session.question?.type == .singleChoice)
        #expect(session.question?.options?.map(\.id) == ["very_stable", "unpredictable"])
        #expect(session.question?.validation?.required == true)
        #expect(session.question?.description == nil)
        #expect(session.result == nil)
        #expect(session.progress.current == 1)
        #expect(session.progress.total == 5)
    }

    @Test("An in-progress multiple-choice session decodes its selection limits")
    func multipleChoiceSessionDecodes() throws {
        let session = try decoder.decode(SessionClientModel.self, from: SessionJSON.multipleChoiceInProgress)

        #expect(session.question?.type == .multipleChoice)
        #expect(session.question?.description == "Select up to three goals.")
        #expect(session.question?.validation?.minSelections == 1)
        #expect(session.question?.validation?.maxSelections == 3)
    }

    @Test("An in-progress number session decodes its range and has no options")
    func numberSessionDecodes() throws {
        let session = try decoder.decode(SessionClientModel.self, from: SessionJSON.numberInProgress)

        #expect(session.question?.type == .number)
        #expect(session.question?.options == nil)
        #expect(session.question?.validation?.min == 0)
        #expect(session.question?.validation?.max == 36)
    }

    @Test("A question without validation decodes with no validation")
    func questionWithoutValidationDecodes() throws {
        let session = try decoder.decode(SessionClientModel.self, from: SessionJSON.questionWithoutValidation)

        #expect(session.question?.validation == nil)
    }

    @Test("A completed session decodes its result and has no question")
    func completedSessionDecodes() throws {
        let session = try decoder.decode(SessionClientModel.self, from: SessionJSON.completed)

        #expect(session.status == .completed)
        #expect(session.question == nil)
        #expect(session.result?.score == 78)
        #expect(session.result?.category == .good)
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
