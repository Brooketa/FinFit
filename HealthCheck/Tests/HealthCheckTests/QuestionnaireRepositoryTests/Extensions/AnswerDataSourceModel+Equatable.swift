@testable import HealthCheck

extension AnswerDataSourceModel: Equatable {

    public static func == (lhs: AnswerDataSourceModel, rhs: AnswerDataSourceModel) -> Bool {
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
