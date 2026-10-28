import SwiftUI
import CoreUI

struct CounterCard: View {

    let model: Model
    let action: (Action) -> Void

    var body: some View {
        HStack(spacing: Spacing.large.value) {
            Text(model.value, format: .number)
                .textStyle(.title)
                .foregroundStyle(Palette.textPrimary)
                .alignLeading()

            Button(.counterResetButton) {
                action(.reset)
            }

            Button(.counterIncrementButton) {
                action(.increment)
            }
        }
        .tint(Palette.accent)
        .padding(.large)
        .background(Palette.backgroundSecondary, in: .rect(cornerRadius: Constants.cornerRadius))
    }

}

extension CounterCard {

    struct Model {

        let value: Int

    }

}

extension CounterCard {

    enum Action {

        case increment
        case reset

    }

}

private extension CounterCard {

    enum Constants {

        static let cornerRadius: CGFloat = 16

    }

}
