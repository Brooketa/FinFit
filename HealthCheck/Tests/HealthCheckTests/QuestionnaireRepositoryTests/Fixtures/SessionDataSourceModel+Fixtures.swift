import Foundation
@testable import HealthCheck

extension SessionDataSourceModel {

    static func fixture(
        id: UUID = UUID(),
        status: Status = .inProgress,
        question: QuestionDataSourceModel? = .fixture(),
        result: ResultDataSourceModel? = nil,
        progress: ProgressDataSourceModel = .fixture()
    ) -> SessionDataSourceModel {
        SessionDataSourceModel(id: id, status: status, question: question, result: result, progress: progress)
    }

}

extension QuestionDataSourceModel {

    static func fixture(
        id: String = "income_stability",
        title: String = "How predictable is your income?",
        description: String? = nil,
        type: QuestionType = .singleChoice,
        options: [OptionDataSourceModel]? = [.fixture()],
        validation: ValidationDataSourceModel? = .fixture()
    ) -> QuestionDataSourceModel {
        QuestionDataSourceModel(
            id: id,
            title: title,
            description: description,
            type: type,
            options: options,
            validation: validation)
    }

}

extension OptionDataSourceModel {

    static func fixture(id: String = "very_stable", title: String = "Very predictable") -> OptionDataSourceModel {
        OptionDataSourceModel(id: id, title: title)
    }

}

extension ValidationDataSourceModel {

    static func fixture(
        required: Bool? = true,
        min: Double? = nil,
        max: Double? = nil,
        minSelections: Int? = nil,
        maxSelections: Int? = nil
    ) -> ValidationDataSourceModel {
        ValidationDataSourceModel(
            required: required,
            min: min,
            max: max,
            minSelections: minSelections,
            maxSelections: maxSelections)
    }

}

extension ResultDataSourceModel {

    static func fixture(score: Int = 78, category: Category = .good) -> ResultDataSourceModel {
        ResultDataSourceModel(score: score, category: category)
    }

}

extension ProgressDataSourceModel {

    static func fixture(current: Int = 1, total: Int = 5) -> ProgressDataSourceModel {
        ProgressDataSourceModel(current: current, total: total)
    }

}
