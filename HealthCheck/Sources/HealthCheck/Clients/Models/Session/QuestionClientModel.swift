struct QuestionClientModel: Decodable, Sendable {

    enum QuestionType: String, Decodable, Sendable {

        case singleChoice = "single_choice"
        case multipleChoice = "multiple_choice"
        case number

    }

    let id: String
    let title: String
    let description: String?
    let type: QuestionType
    let options: [OptionClientModel]?
    let validation: ValidationClientModel?

}
