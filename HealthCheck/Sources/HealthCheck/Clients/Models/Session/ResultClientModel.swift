struct ResultClientModel: Decodable, Sendable {

    enum Category: String, Decodable, Sendable {

        case poor
        case fair
        case good
        case excellent

    }

    let score: Int
    let category: Category

}
