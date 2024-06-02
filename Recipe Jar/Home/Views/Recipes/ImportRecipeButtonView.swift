import SwiftUI
struct ImportRecipeButtonView: View {
    let horizontalPadding: CGFloat
    let action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image("fabadd")
                .resizable()
                .frame(width: 56, height: 56)
                .shadow(radius: 3)
                .padding([.trailing],horizontalPadding)
                .padding(.bottom,10)
        }
    }
}
