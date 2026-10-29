import Foundation

final class QuestionnaireRepository: QuestionnaireRepositoryProtocol {

    private let questionnaireDataSource: any QuestionnaireDataSourceProtocol

    init(questionnaireDataSource: any QuestionnaireDataSourceProtocol) {
        self.questionnaireDataSource = questionnaireDataSource
    }

    func startOrResumeSession(id: UUID) async throws -> SessionRepositoryModel {
        let session = try await questionnaireDataSource.startOrResumeSession(id: id)

        return SessionRepositoryModel(from: session)
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerRepositoryModel
    ) async throws -> SessionRepositoryModel {
        let session = try await questionnaireDataSource.submitAnswer(
            sessionID: sessionID,
            questionID: questionID,
            answer: AnswerDataSourceModel(from: answer))

        return SessionRepositoryModel(from: session)
    }

}
