@testable import HealthCheck

extension AnswerRepositoryModel: Equatable {

    public static func == (lhs: AnswerRepositoryModel, rhs: AnswerRepositoryModel) -> Bool {
        switch (lhs, rhs) {
        case (.option(let lhsID), .option(let rhsID)):
            lhsID == rhsID
        case (.options(let lhsIDs), .options(let rhsIDs)):
            lhsIDs == rhsIDs
        case (.number(let lhsValue), .number(let rhsValue)):
            lhsValue == rhsValue
        default:
            false
        }
    }

}
