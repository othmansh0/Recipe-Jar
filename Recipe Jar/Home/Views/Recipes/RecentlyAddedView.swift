//
//  RecentlyAddedView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/12/2023.
//

import SwiftUI

struct RecentlyAddedView: View {
    @ObservedObject var vm: HomeScreenViewModel
    var isHomeInfoRecieved: Bool
    var isCategoriesRecieved: Bool
    let showRecipe: (Recipe) -> Void
    let showFAQ: () -> Void
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        if vm.recentlyAddedRecipes.count == 0 && isHomeInfoRecieved {
            RecentlyAddedEmptyView(horizontalPadding: horizontalPadding, showFAQ: showFAQ)
        }
        else {
            VStack(alignment: .leading) {
                Text("Recently Added")
                    .font(CustomFont.medium.font(.poppins, size: 20))
                    .foregroundColor(Color(uiColor: .navy))
                    .padding(.leading, horizontalPadding)
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack (spacing: 8) {
                        ForEach(Array(!isHomeInfoRecieved ? Recipe.dummyRecipes(count: 4).enumerated() : vm.recentlyAddedRecipes.enumerated()), id:\.1.id) { (index,recipe) in
                            RecipeView(recipe: recipe, vm: vm.recipeViewModel)
                                .padding(.leading,index == 0 ? horizontalPadding : 0)
                                .padding(.trailing,index == vm.recentlyAddedRecipes.count-1 ? horizontalPadding : 0)
                                .onTapGesture { !isHomeInfoRecieved ? {}() : showRecipe(recipe)}
                                //.redactShimmer(condition: !isHomeInfoRecieved)
                                .redactShimmer(condition: !isCategoriesRecieved  && !isHomeInfoRecieved)
                        }
                    }
                }
            }
        }
    }
}



