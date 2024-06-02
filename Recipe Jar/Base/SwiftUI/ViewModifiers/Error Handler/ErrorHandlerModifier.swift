import SwiftUI
struct ErrorHandlerModifier: ViewModifier {
    @Binding var error: IdentifiableError?
    var onDismiss: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .alert(item: $error) { error in
                Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("OK"), action: onDismiss ?? {})
                )
            }
    }
}

extension View {
    func handleError(_ error: Binding<IdentifiableError?>, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ErrorHandlerModifier(error: error, onDismiss: onDismiss))
    }
}


struct IdentifiableError: Identifiable, Error {
    let id = UUID()
    let error: Error
    
    var localizedDescription: String {
        return (error as? NetworkError)?.localizedDescription ?? error.localizedDescription
    }
}
