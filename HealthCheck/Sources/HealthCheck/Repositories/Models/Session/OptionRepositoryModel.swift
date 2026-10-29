struct OptionRepositoryModel: Sendable {

    let id: String
    let title: String

}

extension OptionRepositoryModel {

    init(from model: OptionDataSourceModel) {
        self.init(id: model.id, title: model.title)
    }

}
