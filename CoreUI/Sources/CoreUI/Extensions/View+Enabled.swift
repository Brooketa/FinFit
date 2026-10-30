import SwiftUI

public extension View {

    /// Enables the view's controls while `isEnabled` is true and disables them otherwise.
    func enabled(_ isEnabled: Bool) -> some View {
        disabled(!isEnabled)
    }

}
