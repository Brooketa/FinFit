import CoreUI

extension ViewState {

    var loadedContent: Content? {
        guard case .loaded(let content) = self else { return nil }

        return content
    }

    var isError: Bool {
        guard case .error = self else { return false }

        return true
    }

}
