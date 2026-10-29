import Foundation

struct SessionClientModel: Decodable, Sendable {

    enum Status: String, Decodable, Sendable {

        case inProgress = "in_progress"
        case completed

    }

    let sessionId: UUID
    let status: Status
    let question: QuestionClientModel?
    let result: ResultClientModel?
    let progress: ProgressClientModel

}
