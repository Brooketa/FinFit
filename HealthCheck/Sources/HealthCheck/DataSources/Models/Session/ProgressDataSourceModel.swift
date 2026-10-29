struct ProgressDataSourceModel: Sendable {

    let current: Int
    let total: Int

}

extension ProgressDataSourceModel {

    init(from model: ProgressClientModel) {
        self.init(current: model.current, total: model.total)
    }

}
