@testable import HealthCheck

extension SessionUseCaseModel {

    static func fixture(
        question: QuestionUseCaseModel = .fixture(),
        progress: ProgressUseCaseModel = .fixture()
    ) -> SessionUseCaseModel {
        .inProgress(question: question, progress: progress)
    }

    static func completedFixture(result: ResultUseCaseModel = .fixture()) -> SessionUseCaseModel {
        .completed(result: result)
    }

}
