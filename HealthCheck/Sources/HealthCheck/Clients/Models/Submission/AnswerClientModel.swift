enum AnswerClientModel: Encodable, Sendable {

    case option(String)
    case options([String])
    case number(Double)

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .option(let id):
            try container.encode(id)
        case .options(let ids):
            try container.encode(ids)
        case .number(let value):
            try container.encode(value)
        }
    }

}
