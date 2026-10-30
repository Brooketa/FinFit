import Foundation
import Testing

enum JSONFixture {

    enum Name {

        static let singleChoiceSession = "session_in_progress_single_choice"
        static let multipleChoiceSession = "session_in_progress_multiple_choice"
        static let numberSession = "session_in_progress_number"
        static let sessionWithoutValidation = "session_in_progress_without_validation"
        static let completedSession = "session_completed"

    }

    static func data(named name: String) throws -> Data {
        let url = try #require(Bundle.module.url(forResource: name, withExtension: "json"))

        return try Data(contentsOf: url)
    }

}
