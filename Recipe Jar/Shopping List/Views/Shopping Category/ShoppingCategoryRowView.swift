//
//  ShoppingCategoryRowView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI
struct ShoppingCategoryRowView: View {
    var category: ShoppingListCategory
    let showShoppingListScreen: (ShoppingListCategory) -> Void
    var body: some View {
            //MARK: Category row
            VStack(alignment: .leading,spacing: 0) {
                //MARK: Category right labels
                HStack(spacing: 10) {
                    Text(category.icon ?? "")
                    Text(category.name.limited(to: 30))
                        .font(CustomFont.medium.font(size: 15))
                    Spacer()
                    Text(String(category.numberOfItems ?? 0))
                        .foregroundColor(CustomColor.lightGrey)
                        .font(CustomFont.medium.font(size: 16))
                        .padding(.trailing,5)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 8,height: 14)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(uiColor: .navy))
                }
                    .padding(.vertical,12)
                Divider()
                    .frame(height: 1)
            }
        .contentShape(Rectangle())
        .onTapGesture { showShoppingListScreen(category) }
        
    }
}
