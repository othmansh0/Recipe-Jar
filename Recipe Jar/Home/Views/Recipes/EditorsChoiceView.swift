//
//  EditorsChoiceView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/12/2023.
//

import SwiftUI
struct EditorsChoiceView: View {
    
    var editorsChoiceRecipes: [Recipe]
    var isHomeInfoRecieved: Bool
    @State var isCategoriesRecieved: Bool
    
    private let horizontalPadding: CGFloat = 24
    let showRecipe: (Recipe) -> Void
    
    var body: some View {
        let shouldShimmer = !isCategoriesRecieved  && !isHomeInfoRecieved
        Text("Picked for You")
            .font(CustomFont.medium.font(.poppins, size: 20))
            .foregroundColor(Color(uiColor: .navy))
            .padding(.top, 25)
            .padding(.leading,horizontalPadding)
        //MARK: Editor's Choice
        ScrollView(.horizontal,showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(shouldShimmer ? Recipe.dummyRecipes(count: 4).enumerated() : editorsChoiceRecipes.enumerated()), id:\.1.id) { (index,recipe) in
                    PickedRecipeView(recipe: recipe)
                        .redactShimmer(condition: shouldShimmer)
                        .onTapGesture { shouldShimmer ? {}() : showRecipe(recipe)}
                        .padding(.leading,index == 0 ? horizontalPadding : 0)
                        .padding(.trailing,index == editorsChoiceRecipes.count-1 ? horizontalPadding : 0)
                }
            }
        }
    }
}
