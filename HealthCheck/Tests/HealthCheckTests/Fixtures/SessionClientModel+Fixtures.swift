import Foundation
@testable import HealthCheck

extension SessionClientModel {

    static func fixture(
        sessionId: UUID = UUID(),
        status: Status = .inProgress,
        question: QuestionClientModel? = .fixture(),
        result: ResultClientModel? = nil,
        progress: ProgressClientModel = .fixture()
    ) -> SessionClientModel {
        SessionClientModel(sessionId: sessionId, status: status, question: question, result: result, progress: progress)
    }

    static func fixture(json name: String) throws -> SessionClientModel {
        try JSONDecoder().decode(SessionClientModel.self, from: JSONFixture.data(named: name))
    }

}

extension QuestionClientModel {

    static func fixture(
        id: String = "income_stability",
        title: String = "How predictable is your income?",
        description: String? = nil,
        type: QuestionType = .singleChoice,
        options: [OptionClientModel]? = [.fixture()],
        validation: ValidationClientModel? = .fixture()
    ) -> QuestionClientModel {
        QuestionClientModel(
            id: id,
            title: title,
            description: description,
            type: type,
            options: options,
            validation: validation)
    }

}

extension OptionClientModel {

    static func fixture(id: String = "very_stable", title: String = "Very predictable") -> OptionClientModel {
        OptionClientModel(id: id, title: title)
    }

}

extension ValidationClientModel {

    static func fixture(
        required: Bool? = true,
        min: Double? = nil,
        max: Double? = nil,
        minSelections: Int? = nil,
        maxSelections: Int? = nil
    ) -> ValidationClientModel {
        ValidationClientModel(
            required: required,
            min: min,
            max: max,
            minSelections: minSelections,
            maxSelections: maxSelections)
    }

}

extension ResultClientModel {

    static func fixture(score: Int = 78, category: Category = .good) -> ResultClientModel {
        ResultClientModel(score: score, category: category)
    }

}

extension ProgressClientModel {

    static func fixture(current: Int = 1, total: Int = 5) -> ProgressClientModel {
        ProgressClientModel(current: current, total: total)
    }

}
