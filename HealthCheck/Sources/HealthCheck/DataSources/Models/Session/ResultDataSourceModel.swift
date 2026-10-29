struct ResultDataSourceModel: Sendable {

    enum Category: Sendable {

        case poor
        case fair
        case good
        case excellent

    }

    let score: Int
    let category: Category

}

extension ResultDataSourceModel {

    init(from model: ResultClientModel) {
        self.init(score: model.score, category: Category(from: model.category))
    }

}

extension ResultDataSourceModel.Category {

    init(from category: ResultClientModel.Category) {
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
