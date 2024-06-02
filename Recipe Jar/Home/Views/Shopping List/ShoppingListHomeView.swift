//
//  ShoppingListHomeView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/12/2023.
//

import SwiftUI

struct ShoppingListHomeView: View {
    @ObservedObject var vm: HomeScreenViewModel
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    var isHomeInfoRecieved: Bool
    var isCategoriesRecieved: Bool
    let showShoppingList: () -> Void
    
    private let horizontalPadding: CGFloat = 24
    var hideShoppingList: Bool { return vm.selectedShoppingList?.selectedShoppingCategory?.name.isEmpty ?? true}
   
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                //MARK: shopping list section
                Text("Shopping List")
                    .font(CustomFont.medium.font(.poppins, size: 20))
                    .foregroundColor(Color(uiColor: .navy))
                    .padding(.top, 25)
                    .padding(.horizontal, horizontalPadding)
                    .isHidden(hideShoppingList,remove: hideShoppingList)
                ShoppingListCardView(vm: vm, shoppingListVM: shoppingListVM, showChooseList: $vm.isChooseListPresented, showShoppingList: showShoppingList)
                    .padding(.top, 10)
                    .redactShimmer(condition: !isCategoriesRecieved  || !isHomeInfoRecieved)
            }
            if vm.isChooseListPresented {
                ChooseListsView(vm: vm, shoppingListVM: shoppingListVM, showChooseList: $vm.isChooseListPresented )
                    .transition(.scale)
                    .padding(.horizontal, horizontalPadding)
            }
        }
        .redactShimmer(condition: !isCategoriesRecieved  || !isHomeInfoRecieved)
    }
}
