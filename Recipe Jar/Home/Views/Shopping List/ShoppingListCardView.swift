import SwiftUI
import Combine
struct ShoppingListCardView: View {
    @ObservedObject var vm: HomeScreenViewModel
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    @Binding var showChooseList: Bool
    let showShoppingList: () -> Void
    
    let rows = [GridItem(.fixed(35)), GridItem(.fixed(35))]
    private let horizontalPadding: CGFloat = 24
    private let borderWidth: CGFloat = 1
    var loadingCondition: Bool { return !shoppingListVM.isCategoriesRecieved || !vm.isHomeInfoRecieved }
    var body: some View {
        if let selectedShoppingList = vm.selectedShoppingList,!(selectedShoppingList.selectedShoppingCategory?.name.isEmpty ?? true) {
            if let items = vm.selectedShoppingList?.items, !items.isEmpty {
                VStack(alignment: .leading, spacing: -8) {
                    ShoppingListWidgetHeaderView(selectedShoppingList: selectedShoppingList, showChooseList: $showChooseList)
                        .zIndex(1)
                        .padding(.horizontal, horizontalPadding)
                        .isHidden(selectedShoppingList.items.isEmpty, remove: selectedShoppingList.items.isEmpty)
                    Group {
                        if vm.categories.count > 0 || loadingCondition {
                            LazyHGrid(rows: rows, alignment: .top, spacing: 20) {
                                var chosenCategory = loadingCondition ? ShoppingListCategory.dummyCategories(count: 1).first! : vm.selectedShoppingList?.selectedShoppingCategory
                                ForEach(Array(zip(items.prefix(4).indices, items.prefix(4))), id: \.1.id) { num, item in
                                    ShoppingItemCardView(item: item, shoppingListVM: shoppingListVM, action: {
                                        await vm.tickItemInHome(itemId: item.id)
                                    })
                                    .padding(.trailing, 17)
                                }
                                .onChange(of: vm.selectedCategoryIndex) { newIndexOfSelectCategory in
                                    chosenCategory = vm.categories[newIndexOfSelectCategory]
                                    vm.selectedShoppingList?.selectedShoppingCategory = chosenCategory
                                    vm.selectedCategory = vm.categories[newIndexOfSelectCategory]
                                    Task { await vm.getSelectedList() }
                                }
                            }
                            .padding(.top, 18)
                            .padding(.bottom, 10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, horizontalPadding + borderWidth)
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(Color(hex: "D9D9D9", opacity: 0.35), lineWidth: borderWidth)
                            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 0)
                            .foregroundStyle(.white)
                    )
                    .zIndex(-1)
                    .padding(.horizontal, horizontalPadding + borderWidth)
                }
            }
            else {
                ShoppingListCardEmtpyView(shoppingListVM: shoppingListVM, showChooseList: $showChooseList, showShoppingList: showShoppingList)
            }
        }
        else {
            EmptyView()
        }
    }
}




