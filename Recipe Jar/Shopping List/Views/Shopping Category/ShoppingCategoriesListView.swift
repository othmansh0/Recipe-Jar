//
//  ShoppingCategoriesListView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI

struct ShoppingCategoriesListView: View {
    var categories: [ShoppingListCategory]
    let showShoppingListScreen: (ShoppingListCategory) -> Void
    var body: some View {
        //MARK: Categories
        List {
            ForEach(Array(zip(categories.indices,categories)),id:\.1.id) { index,category in
                ShoppingCategoryRowView(category: category,showShoppingListScreen: showShoppingListScreen)

                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                    .background(.red)
                
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
