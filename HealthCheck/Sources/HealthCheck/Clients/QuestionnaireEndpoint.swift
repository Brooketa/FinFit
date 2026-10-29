import Foundation
import Networking

enum QuestionnaireEndpoint: Endpoint {

    case startOrResumeSession(id: UUID)
    case submitAnswer(sessionID: UUID, submission: SubmissionClientModel)

    var path: String {
        switch self {
        case .startOrResumeSession(let id):
            "/health-check/v1/sessions/\(id.uuidString.lowercased())"
        case .submitAnswer(let sessionID, _):
            "/health-check/v1/sessions/\(sessionID.uuidString.lowercased())/submission"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .startOrResumeSession, .submitAnswer:
            .post
        }
    }

    var body: (any Encodable & Sendable)? {
        switch self {
        case .startOrResumeSession:
            nil
        case .submitAnswer(_, let submission):
            submission
        }
    }

}
