import Observation
import Home

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {

        case about

    }

    var path: [Destination] = []

}

// MARK: HomeRoutingProtocol

extension AppRouter: HomeRoutingProtocol {

    func navigateToAbout() {
        path.append(.about)
    }

}
