import SwiftUI
import Combine
struct HomeScreen: View {
    
    @ObservedObject var vm: HomeScreenViewModel
    @ObservedObject var folderViewModel: FolderViewModel
    @ObservedObject var shoppingListVM: ShoppingListViewModel
    
    var showRecipe: (Recipe) -> Void
    let showFAQ: () -> Void
    let showShoppingList: () -> Void
    
    @FocusState private var isSearchfoucsed: FocusElement?
    @State private var searchText = ""
    @State private var cancellables: Set<AnyCancellable> = []
    @State private var isLoading: Bool = false //inital is false for mock data only :)
    @State private var refresherState: RefresherState = RefresherState(mode: .refreshing, modeAnimated: .refreshing)
    @State private var isRefreshing = false
    
    private let columns = [GridItem(.adaptive(minimum: 150))]
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        BaseScreen(isLoading: [$isLoading],isLoadingHidden: .constant(true),alertMessage: $vm.alertMessage ,error: $vm.error) {
            ZStack(alignment: .leading) {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack{
                            //MARK: search bar
                            SearchFieldView(searchText: $searchText, focus: _isSearchfoucsed, cancelAction: cancelSearchBar)
                                .padding(.horizontal, horizontalPadding)
                                .id("top")
                            
                            if searchText.isEmpty{
                                //Home screen content
                                LazyVStack (alignment: .leading){
                                    RecentlyAddedView(vm: vm,isHomeInfoRecieved:!isLoading, isCategoriesRecieved: !isLoading, showRecipe: showRecipe,showFAQ: showFAQ)
                                    ShoppingListHomeView(vm: vm, shoppingListVM: shoppingListVM,isHomeInfoRecieved:!isLoading, isCategoriesRecieved: !isLoading, showShoppingList: showShoppingList)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                    //MARK: editor's choice section
                                    EditorsChoiceView(editorsChoiceRecipes: vm.editorsChoiceRecipes,isHomeInfoRecieved: !isLoading, isCategoriesRecieved: !isLoading, showRecipe: showRecipe)
                                        .padding(.bottom,15)
                                }
                                .padding(.top, 25)
                            }
                            else {
                                RecipesGridView(columns:columns,
                                                spacing: 27,
                                                recipes: vm.recipesToSearch.filter{$0.title.localizedCaseInsensitiveContains(searchText)},
                                                vm: vm.recipeViewModel,
                                                showRecipeDetail: showRecipe)
                            }
                        }
                        .disabled(isLoading)
                    }
                    .refresher(isRefreshing: $isRefreshing, refreshView: { bindingState in
                        LottieRefreshView(state: $refresherState)
                    }, action: {
                        isRefreshing = true
                        try! await Task.sleep(nanoseconds: 2_000_000_000)
//                        await loadAllData()
                            isRefreshing = false
                    }
                    )
                    .onDisappear { proxy.scrollTo("top") }
                }
            }
            .overlay(alignment:.bottomTrailing) {
                ImportRecipeButtonView(horizontalPadding: horizontalPadding, action: {vm.showImportRecipeAlert = true})
            }
        }
        .importRecipeAlert(isPresented: $vm.showImportRecipeAlert, importRecipeURL: $vm.importRecipeURL, importRecipeAction: {
            vm.importRecipeFromURL()
        }, scrapeRecipeDetails: {
            await vm.scrapeRecipeDetails(recipeURL: vm.importRecipeURL)
        })
        
        .sheet(isPresented: $vm.showScannerSheet) {
            ScannerView(completion: { textPerPage in vm.handleScannedText(textPerPage: textPerPage) }, cancelAction:  {
                vm.cancelScannerSheet()
            })
        }
        
        .onAppear {
            if vm.selectedShoppingList?.selectedShoppingCategory?.id == shoppingListVM.selectedCategory.id {
                vm.selectedShoppingList?.items = shoppingListVM.items
            }
        }
        .onFirstAppearAsync {
            observeLoadingStates()
            await loadAllData()
        }
        
        .task {
            vm.categories = shoppingListVM.categories
            await vm.getSelectedList()
            //            if vm.selectedShoppingList?.selectedShoppingCategory?.name.isEmpty ?? true && !shoppingListVM.categories.isEmpty || (vm.selectedShoppingList?.selectedShoppingCategory?.id == shoppingListVM.deletedCategoryID) {
            //                if let firstCategory = shoppingListVM.categories.first {
            //                    //                    vm.selectedShoppingList?.selectedShoppingCategory = firstCategory
            //                    //HERE call set selected api
            //                    vm.selectedCategory = firstCategory
            //                    await vm.selectShoppingList()
            //                }
            //            }
        }
    }
    
  
    
    private func cancelSearchBar() {
        isSearchfoucsed = nil
        searchText = ""
    }
    
    private func observeLoadingStates() {
        //        // Combine the loading states of three view models
        //        Publishers.CombineLatest3(vm.$isLoading, folderViewModel.$isLoading, shoppingListVM.$isLoading)
        //            .map { $0 || $1 || $2 } // Combine the three Boolean states into one
        //            .removeDuplicates() // Only react to changes
        //            .assign(to: \.isLoading, on: self)
        //            .store(in: &cancellables)
    }
    
    private func loadAllData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.vm.getRecentlyAddedRecipes() }
            group.addTask { await self.vm.getEditorsChoiceRecipes() }
            group.addTask { await self.vm.getAllRecipes() }
            group.addTask { await self.folderViewModel.getFolders(hideLoading: false) }
            group.addTask {
                let categories = await self.shoppingListVM.getCategories()
                await vm.updateCategories(categories)
                //Some handling have been removed
            }
        }
    }
}

enum FocusElement: Hashable {
    case search
}


