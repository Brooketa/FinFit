struct SubmissionClientModel: Encodable, Sendable {

    let questionId: String
    let answer: AnswerClientModel

}
