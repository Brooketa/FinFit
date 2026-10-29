enum AnswerUseCaseModel: Sendable {

    case option(String)
    case options([String])
    case number(Double)

}

extension AnswerRepositoryModel {

    init(from model: AnswerUseCaseModel) {
        switch model {
        case .option(let id):
            self = .option(id)
        case .options(let ids):
            self = .options(ids)
        case .number(let value):
            self = .number(value)
        }
    }

}
