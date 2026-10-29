struct ProgressRepositoryModel: Sendable {

    let current: Int
    let total: Int

}

extension ProgressRepositoryModel {

    init(from model: ProgressDataSourceModel) {
        self.init(current: model.current, total: model.total)
    }

}
