import SwiftUI
struct ItemsListView: View {
    
    @ObservedObject var vm: ShoppingListViewModel
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false) {
            ForEach(Array(zip(vm.isLoading ? ShoppingListItem.dummyItems(count: 10).indices : $vm.items.indices,
                              vm.isLoading ? .constant(ShoppingListItem.dummyItems(count: 10)) : $vm.items)), id:\.0) { index,$item in
                //MARK: Item row
                ItemCellView(item: $item,vm: vm)
                    .id(item.id)
                    .padding(.horizontal,24)
                    .swipeModifier(color: .red, icon: "trash", action: {
                        vm.itemToDelete = item
                        Task { await vm.deleteItem() }
                    })
                    .redactShimmer(condition: vm.isLoading)
                    .disabled(vm.isLoading)
            }
        }
    }
}
