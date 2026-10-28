import Foundation

public extension Bundle {

    /// The bundle's `CFBundleShortVersionString`, or an empty string when it has none.
    var marketingVersion: String {
        object(forInfoDictionaryKey: Constants.marketingVersionKey) as? String ?? ""
    }

}

private extension Bundle {

    enum Constants {

        static let marketingVersionKey = "CFBundleShortVersionString"

    }

}
