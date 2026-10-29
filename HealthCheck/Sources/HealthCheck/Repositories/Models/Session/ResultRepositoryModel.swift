struct ResultRepositoryModel: Sendable {

    enum Category: Sendable {

        case poor
        case fair
        case good
        case excellent

    }

    let score: Int
    let category: Category

}

extension ResultRepositoryModel {

    init(from model: ResultDataSourceModel) {
        self.init(score: model.score, category: Category(from: model.category))
    }

}

extension ResultRepositoryModel.Category {

    init(from category: ResultDataSourceModel.Category) {
        switch category {
        case .poor:
            self = .poor
        case .fair:
            self = .fair
        case .good:
            self = .good
        case .excellent:
            self = .excellent
        }
    }

}
