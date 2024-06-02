import SwiftUI
struct ShoppingListWidgetHeaderView: View {
    var selectedShoppingList: SelectedShoppingList?
    @Binding var showChooseList: Bool
    var body: some View {
        HStack(spacing: 4){
            Text(selectedShoppingList?.selectedShoppingCategory?.icon ?? "🗂️")
            Text(selectedShoppingList?.selectedShoppingCategory?.name ?? "")
            Spacer()
            Button {
                withAnimation(.popUpAnimation()) { showChooseList = true}
            } label: {
                Image("info")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24,height: 24)
                   
            }
        }
        .font(CustomFont.medium.font(size: 13))
        .foregroundStyle(Color(hex:"333333"))
        .padding(.trailing,2)
        .padding(.leading,10)
        .padding(.vertical,4)
        .background(
            RoundCornerShape(corners: [.topLeft,.topRight], radius: 9)
                        .fill(Color(hex:"F5F1F5")))
    }
}

