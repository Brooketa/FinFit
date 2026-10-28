import SwiftUI

public extension View {

    /// Sets the view's font to the given style from the type scale.
    func textStyle(_ style: TextStyle) -> some View {
        font(style.font)
    }

}
