import SwiftUI
import UIKit
import Kingfisher
struct RecipeDetailScreen: View {
    
    @ObservedObject var vm:RecipeViewModelImpl
    let recipe:Recipe
    let showSteps: (Double) -> Void
   
    //Add ingredient to shopping list
    @StateObject var shoppingListVM = ShoppingListViewModel()
    @ObservedObject var homeViewModel: HomeScreenViewModel
 
    @State private var scale: Double = 1.0
    @State private var showScaleView: Bool = false
    @State private var showChooseList: Bool = false
    //Share as PDF
    @State private var shareLink: ShareLink?
        
    var body: some View {
        BaseScreen(isLoading: [.constant(false)],isTabBarHidden: true, error: $vm.error) {
            VStack (alignment: .leading) {
                KFImage(URL(string: recipe.pictureUrl ?? "https://dummyurl.com/dummy/path/defaultRecipeImage/"))
                    .placeholder {
                        Image("defaultRecipeImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height*0.41)
                            .cornerRadius(1)
                            .padding(.bottom,8)
                    }
                    .retry(maxCount: 3, interval: .seconds(5))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height*0.41)
                    .cornerRadius(1)
                    .padding(.bottom,8)
                HStack {
                    Text(recipe.title)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(uiColor: .navy))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    
                    Button { Task{ self.shareLink = await vm.generateShareLink(recipe: recipe) }
                    } label: {
                        Image("share")
                    }
                    .redactShimmer(condition: vm.isLoading)
                    .disabled(vm.isLoading)
                    .sheet(isPresented: $vm.isSharePDFPresented ) {
                        Group {
                            if vm.isLoading {
                                LoadingView(loadingMessage: "Creating PDF",backgroundColor: Color(hex: "#F5F5F5"))
                            }
                            else {
                                ActivityView(activityItems: [shareLink?.url], applicationActivities:nil)
                            }
                        }
                        .ignoresSafeArea(.all)
                    }
                }
                .padding(.horizontal, 20)
                
                HStack {
                    //scale button
                    TagView(title: "Scale", foregroundColor: .navy, fillColor:.primary.withAlphaComponent(0.08), borderColor: .primary.withAlphaComponent(0.08), boderWidth: 1, verticalPadding: 5,horizontalPadding: 14  , tagFont: CustomFont.medium.font(size: 10))
                        .onTapGesture { withAnimation(.easeIn(duration: 0.2)) { showScaleView.toggle() } }
                        .redactShimmer(condition: vm.isLoading)
                        .disabled(vm.isLoading)
                    if vm.selectedRecipe?.time ?? 0 != 0 {
                        let title = String((vm.selectedRecipe?.time!)!) + " Mins"
                        TagView(title: title, foregroundColor: .white, fillColor:.primary, boderWidth: 1,verticalPadding: 5,horizontalPadding: 14, tagFont: CustomFont.medium.font(size: 10))
                    }
                }
                .padding(.horizontal,20)
                
                VStack (alignment: .leading){
                    Text("Ingredients")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(uiColor: .navy))
                        .padding(.bottom,15)
                    
                    IngredientsListView(ingredients: vm.isLoading ? Ingredient.getDummyIngredients()  : vm.selectedRecipeIngredients, homeViewModel: homeViewModel, shoppingListVM: shoppingListVM, scale: $scale, showScaleView: $showScaleView, showChooseList: $showChooseList)
                        .redactShimmer(condition: vm.isLoading)
                        .disabled(vm.isLoading)
                    let buttonTitle = "Start Cooking"
                    ButtonViewV2(buttonTitle: buttonTitle,cornerRadius: 9, buttonColor: Color(uiColor: .primary), titleColor: .white, titleAlignment: .center, titleFont: CustomFont.medium.font(size: 18), function: {
                        showSteps(scale)
                    })
                    .frame(height: 44)
                    .frame(maxWidth: .infinity,alignment: .center)
                    .disabled(vm.isLoading)
                    .opacity(vm.isLoading ? 0.5 : 1)
                }
                .padding(.horizontal,20)
                .padding(.top,10)
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    vm.selectedRecipe = recipe
                    vm.isLoading = false //for mock data project only
                }
                
                .onFirstAppearAsync {
                    if let recipeID = recipe.id {
                        await vm.getRecipeIngredients(recipeID: recipeID)
                        homeViewModel.categories = await shoppingListVM.getCategories()
                    }
                }
                .alert(isPresented: $vm.showAlert){
                    Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
                }
        }
        .overlay(
            Group {
                if showScaleView || showChooseList {
                    Color.clear
                        .zIndex(1)
                        .contentShape(Rectangle())
                        .onTapGesture { withAnimation(.easeIn(duration: 0.2)) { 
                            showScaleView = false
                            showChooseList = false
                        }}
                }
                else {
                    Color.clear
                }
            }
        )
    }
}
