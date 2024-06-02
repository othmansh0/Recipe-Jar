import SwiftUI
public extension View {
    func onFirstAppearAsync(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppearAsync(action: action))
    }
}

private struct FirstAppearAsync: ViewModifier {
    let action: () async -> Void
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}

