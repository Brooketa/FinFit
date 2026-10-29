import SwiftUI
import FactoryKit
import CoreUI

public struct ResultView: View {

    @InjectedObservable(\.resultPresenter) private var presenter

    public init() {}

    public var body: some View {
        Palette.background
            .ignoresSafeArea()
    }

}

#Preview {
    ResultView()
}
