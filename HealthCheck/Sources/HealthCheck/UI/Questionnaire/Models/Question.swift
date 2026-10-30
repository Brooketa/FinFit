struct Question {

    let progress: Double
    let title: String
    let description: String?
    let isRequired: Bool
    let answer: Answer

}

extension Question {

    init(from question: QuestionUseCaseModel, progress: ProgressUseCaseModel) {
        self.init(
            progress: Double(progress.current) / Double(progress.total),
            title: question.title,
            description: question.description,
            isRequired: question.isRequired,
            answer: Answer(from: question.type))
    }

}
