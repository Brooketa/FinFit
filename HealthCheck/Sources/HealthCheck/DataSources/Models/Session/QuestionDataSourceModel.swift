struct QuestionDataSourceModel: Sendable {

    enum QuestionType: Sendable {

        case singleChoice
        case multipleChoice
        case number

    }

    let id: String
    let title: String
    let description: String?
    let type: QuestionType
    let options: [OptionDataSourceModel]?
    let validation: ValidationDataSourceModel?

}

extension QuestionDataSourceModel {

    init(from model: QuestionClientModel) {
        self.init(
            id: model.id,
            title: model.title,
            description: model.description,
            type: QuestionType(from: model.type),
            options: model.options?.map { OptionDataSourceModel(from: $0) },
            validation: model.validation.map { ValidationDataSourceModel(from: $0) })
    }

}

extension QuestionDataSourceModel.QuestionType {

    init(from type: QuestionClientModel.QuestionType) {
        switch type {
        case .singleChoice:
            self = .singleChoice
        case .multipleChoice:
            self = .multipleChoice
        case .number:
            self = .number
        }
    }

}
