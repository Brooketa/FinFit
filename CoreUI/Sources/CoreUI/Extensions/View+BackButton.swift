import SwiftUI

public extension View {

    /// Replaces the navigation bar's system back button with a chevron that runs `action` when tapped, for a screen
    /// whose back should go somewhere other than the previous screen. Swiping back is turned off.
    func backButton(action: @escaping () -> Void) -> some View {
        navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: action) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
    }

}
