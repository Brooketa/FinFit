import Foundation

struct SessionRepositoryModel: Sendable {

    enum Status: Sendable {

        case inProgress
        case completed

    }

    let id: UUID
    let status: Status
    let question: QuestionRepositoryModel?
    let result: ResultRepositoryModel?
    let progress: ProgressRepositoryModel

}

extension SessionRepositoryModel {

    init(from model: SessionDataSourceModel) {
        self.init(
            id: model.id,
            status: Status(from: model.status),
            question: model.question.map { QuestionRepositoryModel(from: $0) },
            result: model.result.map { ResultRepositoryModel(from: $0) },
            progress: ProgressRepositoryModel(from: model.progress))
    }

}

extension SessionRepositoryModel.Status {

    init(from status: SessionDataSourceModel.Status) {
        switch status {
        case .inProgress:
            self = .inProgress
        case .completed:
            self = .completed
        }
    }

}
