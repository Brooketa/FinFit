import SwiftUI
import FactoryKit
import CoreUI

public struct AboutView: View {

    @InjectedObservable(\.aboutPresenter) private var presenter

    public init() {}

    public var body: some View {
        Text(.aboutVersionLabel(version: presenter.version))
            .textStyle(.body)
            .foregroundStyle(Palette.textSecondary)
            .alignCenter()
            .background(Palette.backgroundPrimary)
            .navigationTitle(Text(.aboutTitle))
    }

}
