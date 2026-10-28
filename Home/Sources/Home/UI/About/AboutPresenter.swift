import Foundation
import Observation
import Core

@MainActor
@Observable
public final class AboutPresenter {

    let version: String

    init(bundle: Bundle) {
        version = bundle.marketingVersion
    }

}
