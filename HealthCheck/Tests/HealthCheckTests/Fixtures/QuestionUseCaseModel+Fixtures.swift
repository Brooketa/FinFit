@testable import HealthCheck

extension QuestionUseCaseModel {

    static func fixture(
        id: String = "income_stability",
        title: String = "How predictable is your income?",
        description: String? = nil,
        type: QuestionType = .singleChoice(options: [.fixture(id: "option_1"), .fixture(id: "option_2")]),
        isRequired: Bool = true
    ) -> QuestionUseCaseModel {
        QuestionUseCaseModel(id: id, title: title, description: description, type: type, isRequired: isRequired)
    }

}

extension OptionUseCaseModel {

    static func fixture(id: String = "option_1", title: String = "Option 1") -> OptionUseCaseModel {
        OptionUseCaseModel(id: id, title: title)
    }

}

extension ProgressUseCaseModel {

    static func fixture(current: Int = 1, total: Int = 5) -> ProgressUseCaseModel {
        ProgressUseCaseModel(current: current, total: total)
    }

}

extension ResultUseCaseModel {

    static func fixture(score: Int = 78, category: Category = .good) -> ResultUseCaseModel {
        ResultUseCaseModel(score: score, category: category)
    }

}
