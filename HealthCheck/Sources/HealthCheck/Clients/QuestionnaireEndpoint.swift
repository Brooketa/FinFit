import Foundation
import Networking

enum QuestionnaireEndpoint: Endpoint {

    case startOrResumeSession(id: UUID)

    var path: String {
        switch self {
        case .startOrResumeSession(let id):
            "/health-check/v1/sessions/\(id.uuidString.lowercased())"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .startOrResumeSession:
            .post
        }
    }

}
