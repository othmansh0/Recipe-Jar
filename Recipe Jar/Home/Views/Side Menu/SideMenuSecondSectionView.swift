//
//  SideMenuSecondSectionView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 23/03/2024.
//

import SwiftUI

struct SideMenuSecondSectionView: View {

    let folders: [Folder]
    let categories: [ShoppingListCategory]
    let openFolder: (Folder) -> Void
    let openShoppingList: (ShoppingListCategory) -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 0) {
                SideMenuCollapsibleRowView(
                    hint: "Folders",
                    options: folders,
                    optionsImage: Image("side_menu_folder"),
                    anchor: .bottom
                ) { tappedItem in
                    openFolder(folders.first(where: {$0.id == tappedItem.id})!)
                }
                
                SideMenuCollapsibleRowView(
                    hint: "Shopping Lists",
                    options: categories,
                    optionsImage: Image("side_menu_shopping"),
                    anchor: .bottom
                ) { tappedItem in
                    openShoppingList(categories.first(where: {$0.id == tappedItem.id})!)
                }
                .padding(.top,10)
            }
            .frame(maxWidth: .infinity,alignment: .topLeading)
        }
    }
}
