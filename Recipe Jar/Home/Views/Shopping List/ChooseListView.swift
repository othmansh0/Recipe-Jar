import SwiftUI

struct ChooseListsView: View {
    
    @ObservedObject var vm: HomeScreenViewModel
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    @Binding var showChooseList: Bool
    
    //Add ingredient from recipe detail to shopping list
    @State var isAddItemToShoppingList = false
    @State var ingredientName = ""
    
    var body: some View {
        ZStack(alignment: .topLeading){
            Button {
                hideChooseList()
            } label: {
                Image(systemName: "x.circle")
                    .frame(width: 25,height: 25)
                    .foregroundColor(CustomColor.navy)
            }
            VStack (alignment: .center, spacing: 10){
                Text("Choose List")
                    .fontWeight(.bold)
                    .foregroundColor(CustomColor.navy)
                    .font(.title3)
                    .padding(.top,10)
                
                Text("Select the list you would like to be shown")
                    .font(.caption)
                    .padding(.bottom,10)
                
                List {
                    ForEach(Array(zip(vm.categories.indices, vm.categories)), id: \.0) { (num: Int, category: ShoppingListCategory) in
                        
                        if let selectedCategory = vm.selectedCategory {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundStyle(Color(red: 0.137, green: 0.161, blue: 0.275))
                                    .frame(width:12,height:12,alignment: .trailing)
                                    .isHidden(selectedCategory.id != category.id)
                            }
                            .onTapGesture {
                                if !isAddItemToShoppingList {
                                    hideChooseList()
                                    vm.selectedCategoryIndex = num
                                    vm.selectedCategory = category
                                    Task{
                                        await vm.selectShoppingList()
                                    }
                                }
                                else {
                                    let catID = vm.categories[num].id
                                    shoppingListVM.newItem = ingredientName
                                    hideChooseList()
                                    Task{@MainActor in
                                        await shoppingListVM.createItem(categoryID:catID)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .foregroundColor(Color(uiColor: .navy))
        .padding(.horizontal,20)
        .padding(.bottom,25)
        .padding(.top,15)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 1)
    }
    
    func hideChooseList() {
        withAnimation(.popUpAnimation()){
            showChooseList = false
        }
    }
}



