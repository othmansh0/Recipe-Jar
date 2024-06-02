import SwiftUI
import SafariServices
struct RecipesGridView: View {
    let columns: [GridItem]
    let spacing: CGFloat
    let recipes: [Recipe]
    let vm: RecipeViewModelImpl
    let showRecipeDetail: (Recipe) -> Void


    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(Array(zip(vm.isLoading ? Recipe.dummyRecipes(count: 5).indices : recipes.indices,
                              vm.isLoading ? Recipe.dummyRecipes(count: 5) : recipes)), id: \.0) { num, recipe in
                RecipeView(recipe: recipe, vm: vm)
                    .onTapGesture { showRecipeDetail(recipe) }
                    .contextMenu {
                        Button("Delete") {
                            vm.selectedRecipe = recipe
                            Task { await vm.deleteRecipe() }
                        }
                    }
            }
        }
        .onAppear {
            //false for mock data only :)
            vm.isLoading = false
        }
    }
}
