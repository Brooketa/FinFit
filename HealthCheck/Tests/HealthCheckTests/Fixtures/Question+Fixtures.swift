@testable import HealthCheck

extension Question {

    static func fixture(
        id: String = "income_stability",
        progress: Double = 0.2,
        title: String = "How predictable is your income?",
        description: String? = nil,
        answer: Answer = .singleChoice(options: .fixtures(count: 3))
    ) -> Question {
        Question(id: id, progress: progress, title: title, description: description, answer: answer)
    }

}

extension Question.Answer.Option {

    static func fixture(id: String = "option_1", title: String = "Option 1") -> Question.Answer.Option {
        Question.Answer.Option(id: id, title: title)
    }

}

extension [Question.Answer.Option] {

    static func fixtures(count: Int) -> [Question.Answer.Option] {
        (1...count).map { .fixture(id: "option_\($0)", title: "Option \($0)") }
    }

}
