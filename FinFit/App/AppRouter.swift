import Observation

@MainActor
@Observable
final class AppRouter {

    enum Destination: Hashable {}

    var path: [Destination] = []

}
