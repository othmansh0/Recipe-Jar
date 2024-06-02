import SwiftUI
struct ImportRecipeAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var importRecipeURL: String
    let importRecipeAction: () -> Void
    let scrapeRecipeDetails: () async -> Void

    func body(content: Content) -> some View {
        content
            .alert("Import Recipe", isPresented: $isPresented) {
                TextField("New name", text: $importRecipeURL)
                Button("Add") {
                    importRecipeAction()
                    Task { await scrapeRecipeDetails() }
                }
                Button("Cancel", role: .cancel) { importRecipeURL = "" }
            }
    }
}

extension View {
    func importRecipeAlert(isPresented: Binding<Bool>, importRecipeURL: Binding<String>, importRecipeAction: @escaping () -> Void, scrapeRecipeDetails: @escaping () async -> Void) -> some View {
        self.modifier(ImportRecipeAlertModifier(isPresented: isPresented, importRecipeURL: importRecipeURL, importRecipeAction: importRecipeAction, scrapeRecipeDetails: scrapeRecipeDetails))
    }
}
