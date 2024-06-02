import SwiftUI

struct ItemCellView: View {
    @Binding var item: ShoppingListItem
    //temp array to know which items have been changed so they can be updated in the database
    @StateObject var vm:ShoppingListViewModel
    
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            HStack {
                CircularTickView(isSelected: item.isCheck, selectedColor: Color("yellow"), unselectedColor: .white, borderColor: Color("yellow"),borderWidth: 2, width: 22, height: 22)
                
                Text(item.name.limited(to: 30))
                    .font(CustomFont.medium.font(size: 15))
                Spacer()
            }
            .padding(.vertical,12)
            
            .contentShape(Rectangle())
            .onTapGesture{ vm.tickItem(item: &item)}
            Divider()
                .frame(height: 1)
        }
    }
}

struct CircularTickView: View {
    let isSelected: Bool
    let selectedColor: Color
    let unselectedColor: Color
    let borderColor: Color
    var borderWidth: CGFloat = 1
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        Circle()
            .fill(unselectedColor)
            .frame(width: width, height: height)
            .overlay(
                Group {
                    if !isSelected {
                        Circle()
                            .stroke(borderColor, lineWidth: borderWidth)
                    } else {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundColor(selectedColor)
                            .font(.system(size: 14, weight: .heavy))
                            .frame(width: width + 1, height: height + 1)
                        
                    }
                }
            )
            .animation(.easeInOut(duration: 0.28), value: isSelected)//old value 0.4
        
    }
}
