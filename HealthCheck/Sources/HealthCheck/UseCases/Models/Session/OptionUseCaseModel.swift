struct OptionUseCaseModel: Sendable {

    let id: String
    let title: String

}

extension OptionUseCaseModel {

    init(from model: OptionRepositoryModel) {
        self.init(id: model.id, title: model.title)
    }

}
