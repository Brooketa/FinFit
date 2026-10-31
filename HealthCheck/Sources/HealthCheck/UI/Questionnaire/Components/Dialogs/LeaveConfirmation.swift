import SwiftUI

struct LeaveConfirmation: ViewModifier {

    let isPresented: Binding<Bool>
    let action: (Action) -> Void

    func body(content: Content) -> some View {
        content
            .alert(Text(.questionnaireLeaveTitle), isPresented: isPresented) {
                Button(.questionnaireLeaveSaveButton) {
                    action(.saveAndLeave)
                }

                Button(.questionnaireLeaveDiscardButton, role: .destructive) {
                    action(.discardAndLeave)
                }

                Button(.questionnaireLeaveCancelButton, role: .cancel) {
                    action(.cancel)
                }
            } message: {
                Text(.questionnaireLeaveMessage)
            }
    }

}

extension LeaveConfirmation {

    enum Action {

        case saveAndLeave
        case discardAndLeave
        case cancel

    }

}

extension View {

    func leaveConfirmationAlert(
        isPresented: Binding<Bool>,
        action: @escaping (LeaveConfirmation.Action) -> Void
    ) -> some View {
        modifier(LeaveConfirmation(isPresented: isPresented, action: action))
    }

}
