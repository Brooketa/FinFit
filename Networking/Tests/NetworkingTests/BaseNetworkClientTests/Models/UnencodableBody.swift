struct UnencodableBody: Encodable, Sendable {

    func encode(to encoder: any Encoder) throws {
        throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: [], debugDescription: "Unencodable"))
    }

}
