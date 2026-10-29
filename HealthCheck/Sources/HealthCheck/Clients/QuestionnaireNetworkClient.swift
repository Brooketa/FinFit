import Foundation
import Networking

final class QuestionnaireNetworkClient: QuestionnaireNetworkClientProtocol {

    private let baseNetworkClient: any BaseNetworkClientProtocol

    init(baseNetworkClient: any BaseNetworkClientProtocol) {
        self.baseNetworkClient = baseNetworkClient
    }

    func startOrResumeSession(id: UUID) async throws -> SessionClientModel {
        try await baseNetworkClient.request(QuestionnaireEndpoint.startOrResumeSession(id: id))
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerClientModel
    ) async throws -> SessionClientModel {
        let submission = SubmissionClientModel(questionId: questionID, answer: answer)

        return try await baseNetworkClient.request(
            QuestionnaireEndpoint.submitAnswer(sessionID: sessionID, submission: submission))
    }

}
