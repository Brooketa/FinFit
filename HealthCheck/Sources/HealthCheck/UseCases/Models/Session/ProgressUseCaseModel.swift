struct ProgressUseCaseModel: Sendable {

    let current: Int
    let total: Int

}

extension ProgressUseCaseModel {

    init(from model: ProgressRepositoryModel) {
        self.init(current: model.current, total: model.total)
    }

}
