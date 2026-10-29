struct ValidationClientModel: Decodable, Sendable {

    let required: Bool?
    let min: Double?
    let max: Double?
    let minSelections: Int?
    let maxSelections: Int?

}
