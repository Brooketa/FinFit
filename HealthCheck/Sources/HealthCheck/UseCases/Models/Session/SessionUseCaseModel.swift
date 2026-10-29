enum SessionUseCaseModel: Sendable {

    case inProgress(question: QuestionUseCaseModel, progress: ProgressUseCaseModel)
    case completed(result: ResultUseCaseModel)

}

extension SessionUseCaseModel {

    init(from model: SessionRepositoryModel) throws {
        switch model.status {
        case .inProgress:
            guard let question = model.question else { throw QuestionnaireUseCaseError.invalidSession }

            self = .inProgress(
                question: QuestionUseCaseModel(from: question),
                progress: ProgressUseCaseModel(from: model.progress))
        case .completed:
            guard let result = model.result else { throw QuestionnaireUseCaseError.invalidSession }

            self = .completed(result: ResultUseCaseModel(from: result))
        }
    }

}
