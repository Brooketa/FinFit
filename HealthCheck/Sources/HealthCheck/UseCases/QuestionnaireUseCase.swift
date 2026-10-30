import Foundation

final class QuestionnaireUseCase: QuestionnaireUseCaseProtocol {

    private let questionnaireRepository: any QuestionnaireRepositoryProtocol

    init(questionnaireRepository: any QuestionnaireRepositoryProtocol) {
        self.questionnaireRepository = questionnaireRepository
    }

    func startOrResumeSession(id: UUID) async throws -> SessionUseCaseModel {
        let session = try await questionnaireRepository.startOrResumeSession(id: id)

        return try SessionUseCaseModel(from: session)
    }

    func submitAnswer(
        sessionID: UUID,
        questionID: String,
        answer: AnswerUseCaseModel
    ) async throws -> SessionUseCaseModel {
        let session = try await questionnaireRepository.submitAnswer(
            sessionID: sessionID,
            questionID: questionID,
            answer: AnswerRepositoryModel(from: answer))

        return try SessionUseCaseModel(from: session)
    }

}
