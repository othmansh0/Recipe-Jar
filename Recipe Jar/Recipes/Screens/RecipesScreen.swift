import SwiftUI
struct RecipesScreen: View {
    
    @ObservedObject var vm: RecipeViewModelImpl
    @State var searchText: String = ""
    @FocusState var enabled: Bool
    var categoryID: Int?
    
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty { return vm.recipes }
        else { return vm.recipes.filter { $0.title.localizedCaseInsensitiveContains(searchText) } }
    }
    
    let showRecipeDetail: (Recipe) -> Void
    
    
    @State private var refresherState: RefresherState = RefresherState(mode: .refreshing, modeAnimated: .refreshing)
    @State private var isRefershing = false
    let columns = [ GridItem(.adaptive(minimum: 150)) ]
    
    var body: some View {
        BaseScreen(isLoading: [$vm.isLoading],isLoadingHidden: .constant(true), error: $vm.error) {
            ScrollView(showsIndicators: false) {
                HStack (spacing: 10){
                    HStack {
                        Image("magnify")
                            .padding(.leading,15)
                        TextField("Search", text: $searchText)
                            .focused($enabled)
                            .foregroundColor(Color(uiColor: .navy))
                            .disableAutocorrection(true)
                            .overlay(
                                withAnimation {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(Color(uiColor: .navy))
                                        .padding()
                                        .opacity(searchText.isEmpty || !enabled  ? 0.0 : 1.0)
                                        .onTapGesture {
                                            searchText = ""
                                        }
                                }
                                ,alignment: .trailing
                            )
                            .onTapGesture {
                                enabled = true
                            }
                    }
                    .frame(height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 9)
                            .fill(CustomColor.searchColor)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(CustomColor.greySearch)
                    )
                    .padding(.top,15)
                    if enabled {
                        Text("Cancel")
                            .frame(height: 46)
                            .padding(.top, 15)
                            .foregroundColor(Color(uiColor: .navy))
                            .onTapGesture {
                                enabled = false
                                searchText = ""
                            }
                    }
                }
                .padding(.horizontal, 32)
                .disabled(isRefershing || vm.isLoading)
                
                RecipesGridView(columns: columns, spacing: 27, recipes: filteredRecipes, vm: vm, showRecipeDetail: showRecipeDetail)
                .redactShimmer(condition: vm.isLoading)
                .padding(.horizontal, 32)
                .padding(.top, 30)
            }
            .refresher(
                isRefreshing: $isRefershing,
                refreshView: { bindingState in
                    LottieRefreshView(state: $refresherState)
                }, action: {
                    isRefershing = true
                    await vm.getAllRecipes(categoryID:categoryID! )
                    isRefershing = false
                }
            )
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        enabled = false
                    }
                }
            }
            .onFirstAppearAsync { await vm.getAllRecipes(categoryID:categoryID! ) }
            .disabled(isRefershing || vm.isLoading)
        }
    }
}



