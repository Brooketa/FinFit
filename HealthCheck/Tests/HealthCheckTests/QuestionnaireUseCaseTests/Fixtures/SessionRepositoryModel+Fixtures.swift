import Foundation
@testable import HealthCheck

extension SessionRepositoryModel {

    static func fixture(
        id: UUID = UUID(),
        status: Status = .inProgress,
        question: QuestionRepositoryModel? = .fixture(),
        result: ResultRepositoryModel? = nil,
        progress: ProgressRepositoryModel = .fixture()
    ) -> SessionRepositoryModel {
        SessionRepositoryModel(id: id, status: status, question: question, result: result, progress: progress)
    }

}

extension QuestionRepositoryModel {

    static func fixture(
        id: String = "income_stability",
        title: String = "How predictable is your income?",
        description: String? = nil,
        type: QuestionType = .singleChoice,
        options: [OptionRepositoryModel]? = [.fixture()],
        validation: ValidationRepositoryModel? = .fixture()
    ) -> QuestionRepositoryModel {
        QuestionRepositoryModel(
            id: id,
            title: title,
            description: description,
            type: type,
            options: options,
            validation: validation)
    }

}

extension OptionRepositoryModel {

    static func fixture(id: String = "very_stable", title: String = "Very predictable") -> OptionRepositoryModel {
        OptionRepositoryModel(id: id, title: title)
    }

    static func fixtures(count: Int) -> [OptionRepositoryModel] {
        (1...count).map { .fixture(id: "option_\($0)", title: "Option \($0)") }
    }

}

extension ValidationRepositoryModel {

    static func fixture(
        required: Bool? = true,
        min: Double? = nil,
        max: Double? = nil,
        minSelections: Int? = nil,
        maxSelections: Int? = nil
    ) -> ValidationRepositoryModel {
        ValidationRepositoryModel(
            required: required,
            min: min,
            max: max,
            minSelections: minSelections,
            maxSelections: maxSelections)
    }

}

extension ResultRepositoryModel {

    static func fixture(score: Int = 78, category: Category = .good) -> ResultRepositoryModel {
        ResultRepositoryModel(score: score, category: category)
    }

}

extension ProgressRepositoryModel {

    static func fixture(current: Int = 1, total: Int = 5) -> ProgressRepositoryModel {
        ProgressRepositoryModel(current: current, total: total)
    }

}
