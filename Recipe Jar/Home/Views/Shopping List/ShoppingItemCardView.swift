import SwiftUI

struct ShoppingItemCardView: View {
    
    @State var item: ShoppingListItem
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    let action: () async -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            //Capsule shape
            HStack {
                VStack (alignment: .leading){
                    Text(item.name)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(uiColor: .navy))
                        .font(.system(size: 10))
                        .offset(x:7)
                        .frame(width: 55, alignment: .leading)
                }
            }
            .frame(width: 94, height: 22)
            .background(CustomColor.purple.opacity(0.08))
            .clipShape(Capsule())
            //Checkmark shape
            ZStack{
                Circle()
                    .fill(item.isCheck ? CustomColor.yellow : .white)
                    .frame(width: 28, height: 28)
                    .onTapGesture{
                        Task {
                            item.isCheck.toggle()
                            await action()
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(CustomColor.yellow, lineWidth: 2)
                    )
                
                if item.isCheck {
                    Image("Tick")
                        .foregroundColor(.white)
                        .font(.system(size:13))
                }
            }
            .offset(x:-10)
        }
    }
}
