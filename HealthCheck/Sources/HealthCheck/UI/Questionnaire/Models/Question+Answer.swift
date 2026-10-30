extension Question {

    enum Answer {

        case singleChoice(options: [Option])
        case multipleChoice(options: [Option], selectionRange: ClosedRange<Int>)
        case number(valueRange: ClosedRange<Double>)

    }

}

extension Question.Answer {

    struct Option {

        let id: String
        let title: String

    }

}

extension Question.Answer {

    init(from type: QuestionUseCaseModel.QuestionType) {
        switch type {
        case .singleChoice(let options):
            self = .singleChoice(options: options.map { Option(from: $0) })
        case .multipleChoice(let options, let selectionRange):
            self = .multipleChoice(options: options.map { Option(from: $0) }, selectionRange: selectionRange)
        case .number(let valueRange):
            self = .number(valueRange: valueRange)
        }
    }

}

extension Question.Answer.Option {

    init(from model: OptionUseCaseModel) {
        self.init(id: model.id, title: model.title)
    }

}
