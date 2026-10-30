public struct HealthCheckResult: Hashable, Sendable {

    let score: Int
    let category: Category

}

extension HealthCheckResult {

    public enum Category: Sendable {

        case poor
        case fair
        case good
        case excellent

    }

}

extension HealthCheckResult {

    init(from model: ResultUseCaseModel) {
        self.init(score: model.score, category: Category(from: model.category))
    }

}

extension HealthCheckResult.Category {

    init(from category: ResultUseCaseModel.Category) {
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
