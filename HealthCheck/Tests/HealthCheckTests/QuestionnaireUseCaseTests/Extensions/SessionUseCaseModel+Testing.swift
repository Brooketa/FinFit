@testable import HealthCheck

extension SessionUseCaseModel {

    var question: QuestionUseCaseModel? {
        guard case .inProgress(let question, _) = self else { return nil }

        return question
    }

    var progress: ProgressUseCaseModel? {
        guard case .inProgress(_, let progress) = self else { return nil }

        return progress
    }

    var result: ResultUseCaseModel? {
        guard case .completed(let result) = self else { return nil }

        return result
    }

}

extension QuestionUseCaseModel.QuestionType {

    var optionIDs: [String]? {
        switch self {
        case .singleChoice(let options), .multipleChoice(let options, _):
            options.map(\.id)
        case .number:
            nil
        }
    }

    var selectionRange: ClosedRange<Int>? {
        guard case .multipleChoice(_, let selectionRange) = self else { return nil }

        return selectionRange
    }

    var valueRange: ClosedRange<Double>? {
        guard case .number(let valueRange) = self else { return nil }

        return valueRange
    }

}
