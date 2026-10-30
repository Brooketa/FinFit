import Foundation

struct ResultSummary {

    let progress: Double
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource

}

extension ResultSummary {

    init(from result: HealthCheckResult) {
        let progress = Double(result.score) / Constants.maximumScore

        switch result.category {
        case .poor:
            self.init(progress: progress, title: .resultPoorTitle, subtitle: .resultPoorSubtitle)
        case .fair:
            self.init(progress: progress, title: .resultFairTitle, subtitle: .resultFairSubtitle)
        case .good:
            self.init(progress: progress, title: .resultGoodTitle, subtitle: .resultGoodSubtitle)
        case .excellent:
            self.init(progress: progress, title: .resultExcellentTitle, subtitle: .resultExcellentSubtitle)
        }
    }

}

private extension ResultSummary {

    enum Constants {

        static let maximumScore: Double = 100

    }

}
