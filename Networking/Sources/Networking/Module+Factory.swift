import Foundation
import FactoryKit

extension Container {

    // MARK: Clients

    public var baseNetworkClient: Factory<any BaseNetworkClientProtocol> {
        self { BaseNetworkClient(baseURL: self.baseURL) }
			.singleton
    }

}

private extension Container {

    enum Constants {

        static let baseURLKey = "APIBaseURL"

    }

    var baseURL: String {
        Bundle.main.object(forInfoDictionaryKey: Constants.baseURLKey) as? String ?? ""
    }

}
