struct QuestionRepositoryModel: Sendable {

    enum QuestionType: Sendable {

        case singleChoice
        case multipleChoice
        case number

    }

    let id: String
    let title: String
    let description: String?
    let type: QuestionType
    let options: [OptionRepositoryModel]?
    let validation: ValidationRepositoryModel?

}

extension QuestionRepositoryModel {

    init(from model: QuestionDataSourceModel) {
        self.init(
            id: model.id,
            title: model.title,
            description: model.description,
            type: QuestionType(from: model.type),
            options: model.options?.map { OptionRepositoryModel(from: $0) },
            validation: model.validation.map { ValidationRepositoryModel(from: $0) })
    }

}

extension QuestionRepositoryModel.QuestionType {

    init(from type: QuestionDataSourceModel.QuestionType) {
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
