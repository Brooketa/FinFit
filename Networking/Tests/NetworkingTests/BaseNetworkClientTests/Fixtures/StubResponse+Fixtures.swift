import Foundation

extension StubResponse {

    static func fixture(statusCode: Int = 200, data: Data = TestResponse.fixture().jsonFixture) -> StubResponse {
        StubResponse(statusCode: statusCode, data: data)
    }

}
