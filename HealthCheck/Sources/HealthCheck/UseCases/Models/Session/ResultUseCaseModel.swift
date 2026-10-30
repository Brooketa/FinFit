struct ResultUseCaseModel: Sendable {

    enum Category: Sendable {

        case poor
        case fair
        case good
        case excellent

    }

    let score: Int
    let category: Category

}

extension ResultUseCaseModel {

    init(from model: ResultRepositoryModel) {
        self.init(score: model.score, category: Category(from: model.category))
    }

}

extension ResultUseCaseModel.Category {

    init(from category: ResultRepositoryModel.Category) {
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
