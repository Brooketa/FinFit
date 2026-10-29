struct QuestionUseCaseModel: Sendable {

    enum QuestionType: Sendable {

        case singleChoice(options: [OptionUseCaseModel])
        case multipleChoice(options: [OptionUseCaseModel], selectionRange: ClosedRange<Int>)
        case number(valueRange: ClosedRange<Double>)

    }

    let id: String
    let title: String
    let description: String?
    let type: QuestionType
    let isRequired: Bool

}

extension QuestionUseCaseModel {

    init(from model: QuestionRepositoryModel) {
        self.init(
            id: model.id,
            title: model.title,
            description: model.description,
            type: QuestionType(from: model),
            isRequired: model.validation?.required ?? false)
    }

}

extension QuestionUseCaseModel.QuestionType {

    init(from model: QuestionRepositoryModel) {
        let options = (model.options ?? []).map { OptionUseCaseModel(from: $0) }
        let validation = model.validation

        switch model.type {
        case .singleChoice:
            self = .singleChoice(options: options)
        case .multipleChoice:
            let isRequired = validation?.required ?? false
            let lowerBound = validation?.minSelections ?? (isRequired ? 1 : 0)
            let upperBound = validation?.maxSelections ?? options.count

            self = .multipleChoice(options: options, selectionRange: lowerBound...max(lowerBound, upperBound))
        case .number:
            let lowerBound = validation?.min ?? -.infinity
            let upperBound = validation?.max ?? .infinity

            self = .number(valueRange: lowerBound...max(lowerBound, upperBound))
        }
    }

}
