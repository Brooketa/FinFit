import Foundation

final class QuestionnaireDataSource: QuestionnaireDataSourceProtocol {

    private let questionnaireNetworkClient: any QuestionnaireNetworkClientProtocol

    init(questionnaireNetworkClient: any QuestionnaireNetworkClientProtocol) {
        self.questionnaireNetworkClient = questionnaireNetworkClient
    }

    func startOrResumeSession(id: UUID) async throws -> SessionDataSourceModel {
        let session = try await questionnaireNetworkClient.startOrResumeSession(id: id)

        return SessionDataSourceModel(from: session)
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerDataSourceModel
    ) async throws -> SessionDataSourceModel {
        let session = try await questionnaireNetworkClient.submitAnswer(
            sessionID: sessionID,
            questionID: questionID,
            answer: AnswerClientModel(from: answer))

        return SessionDataSourceModel(from: session)
    }

}
