import Foundation

struct SessionDataSourceModel: Sendable {

    enum Status: Sendable {

        case inProgress
        case completed

    }

    let id: UUID
    let status: Status
    let question: QuestionDataSourceModel?
    let result: ResultDataSourceModel?
    let progress: ProgressDataSourceModel

}

extension SessionDataSourceModel {

    init(from model: SessionClientModel) {
        self.init(
            id: model.sessionId,
            status: Status(from: model.status),
            question: model.question.map { QuestionDataSourceModel(from: $0) },
            result: model.result.map { ResultDataSourceModel(from: $0) },
            progress: ProgressDataSourceModel(from: model.progress))
    }

}

extension SessionDataSourceModel.Status {

    init(from status: SessionClientModel.Status) {
        switch status {
        case .inProgress:
            self = .inProgress
        case .completed:
            self = .completed
        }
    }

}
