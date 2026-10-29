import SwiftUI
import FactoryKit
import CoreUI

public struct QuestionnaireView: View {

    @InjectedObservable(\.questionnairePresenter) private var presenter

    public init() {}

    public var body: some View {
        Palette.background
            .ignoresSafeArea()
    }

}

#Preview {
    QuestionnaireView()
}
