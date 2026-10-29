import Foundation

enum ResultCategory {

    case poor
    case fair
    case good
    case excellent

    init(for score: Int) {
        switch score {
        case ..<25:
            self = .poor
        case ..<50:
            self = .fair
        case ..<75:
            self = .good
        default:
            self = .excellent
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .poor:
            .resultPoorTitle
        case .fair:
            .resultFairTitle
        case .good:
            .resultGoodTitle
        case .excellent:
            .resultExcellentTitle
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .poor:
            .resultPoorSubtitle
        case .fair:
            .resultFairSubtitle
        case .good:
            .resultGoodSubtitle
        case .excellent:
            .resultExcellentSubtitle
        }
    }

}
