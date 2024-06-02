//
//  IngredientsListView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 30/12/2023.
//

import SwiftUI

struct IngredientsListView: View {

    let ingredients: [Ingredient]
    @ObservedObject var homeViewModel: HomeScreenViewModel
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    
    @Binding var scale: Double
    @State var selectedIngredientName = ""
    @Binding var showScaleView: Bool
    @Binding var showChooseList: Bool
    
    var body: some View {
        ZStack(alignment: .bottom){
            ScrollView(showsIndicators: false){
                ForEach(ingredients, id: \.orderNumber) { ingredient in
                    IngredientView(ingredient: ingredient, selectedIngredientName: $selectedIngredientName, scale: scale,action:{withAnimation(.popUpAnimation()){ showChooseList = true }})
                }
            }
            .frame(height: 268)
            
            if showScaleView {
                ScalingView(scale: $scale)
                    .zIndex(1)
                    .transition(.move(edge: showScaleView ? .bottom : .top))
            }
            if showChooseList {
                ChooseListsView(vm: homeViewModel, shoppingListVM: shoppingListVM, showChooseList: $showChooseList,isAddItemToShoppingList:true,ingredientName:selectedIngredientName)
                    .transition(.scale)
            }
        }
    }
}
