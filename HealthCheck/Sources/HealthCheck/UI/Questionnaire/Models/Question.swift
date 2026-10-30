struct Question {

    let id: String
    let progress: Double
    let title: String
    let description: String?
    let answer: Answer

}

extension Question {

    init(from question: QuestionUseCaseModel, progress: ProgressUseCaseModel) {
        self.init(
            id: question.id,
            progress: Double(progress.current) / Double(progress.total),
            title: question.title,
            description: question.description,
            answer: Answer(from: question.type))
    }

}
