struct OptionDataSourceModel: Sendable {

    let id: String
    let title: String

}

extension OptionDataSourceModel {

    init(from model: OptionClientModel) {
        self.init(id: model.id, title: model.title)
    }

}
