import SwiftUI
import CoreUI

struct RootView: View {

    @Bindable var router: AppRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            Palette.background
                .ignoresSafeArea()
        }
    }

}
