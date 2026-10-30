import Foundation

extension TestResponse {

    static func fixture(id: Int = 1, name: String = "Savings") -> TestResponse {
        TestResponse(id: id, name: name)
    }

    var jsonFixture: Data {
        try! JSONEncoder().encode(self)
    }

}
