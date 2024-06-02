import SwiftUI
struct ShoppingListCardEmtpyView: View {
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    @Binding var showChooseList: Bool
    let showShoppingList: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Add items to cook your")
            Text("special recipes!")
            Spacer()
            ButtonViewV3(buttonTitle: "Add Item", horizontalInnerPadding: 20, verticalInnerPadding: 6, cornerRadius: 31,linearGradient: LinearGradient(gradient: Gradient(colors: [Color(hex: "EDC432"), Color(hex: "FFA927")]), startPoint: .leading, endPoint: .trailing), titleFont: CustomFont.medium.font(.poppins, size: 15), function: { showShoppingList() })
        }
        .foregroundStyle(Color(hex: "5F5F5F"))
        .font(CustomFont.regular.font(size: 16))
        .frame(maxWidth: .infinity,alignment: .center)
        .padding(.vertical, 18)
        .frame(height: 120,alignment: .center)
        .background(RoundedRectangle(cornerRadius: 9)
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 0)
        .foregroundStyle(.white))
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation(.popUpAnimation()) { showChooseList = true}
            } label: {
                Image("info")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24,height: 24)
                    .padding(.trailing,2)
                    .padding(.vertical,4)
            }
        }
        .padding(.horizontal, 24)
    }
}
