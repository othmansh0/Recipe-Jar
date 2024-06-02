import Foundation
import AVFoundation
import SwiftUI

@MainActor
class HomeScreenViewModel: BaseVM {
    
    @Published var isHomeInfoRecieved = false
    @Published var showSideMenu = false
    
    @Published var recipeWithCategories: RecipeWithCategories?
    
    //Recipes
    @Published var recentlyAddedRecipes = [Recipe]()
    @Published var importRecipeURL: String = ""
    @Published var showOcrRecipeSheet: Bool = false
    
    @Published var showUrlRecipeSheet: Bool = false
    
    @Published var recipeViewModel = RecipeViewModelImpl()
    
    @Published var homeScreenInfo: RecentlyAddedRecipes?
    //Shopping List widget
    @Published var selectedShoppingList: SelectedShoppingList?
    @Published var selectedCategory: ShoppingListCategory?
    @Published var categories = [ShoppingListCategory]()
    
    @Published var editorsChoiceRecipes = [Recipe]()
    
    @Published var ocrRecipeWithCategories: RecipeWithCategories?
    
    //@Published var categories = [shoppinglistcate]
    
    @Published var selectedCategoryIndex: Int = 0
    @Published var isChooseListPresented = false
    
    //Side Menu
    @Published var showSafari = false
    
    
    //OCR
    @Published  var showScannerSheet = false
    @Published  var ocrText = ""
    @Published  var ocrRecipe: RecipeWithCategories?
    @Published var showImportRecipeAlert = false
    
    //Search
    @Published var recipesToSearch = [Recipe]()
    
    private var networkService: Networkable
    
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
        super.init()
        isLoading = true
        getCategories()
    }
    
    func getRecentlyAddedRecipes() async {
        if let info: RecentlyAddedRecipes = loadJson(filename: "MockRecentlyAddedRecipes") {
            DispatchQueue.main.async {
                self.homeScreenInfo = info
                self.recentlyAddedRecipes = info.recentlyAddedRecipes
                self.isHomeInfoRecieved = true
            }
        }
        else {
            DispatchQueue.main.async {
                self.isHomeInfoRecieved = false
            }
        }
    }
    
    //A function that gets picked recipes to show to all users in Editor's choice
    func getEditorsChoiceRecipes() async {
        if let recipes: [Recipe] = loadJson(filename: "MockPickedForYouRecipes") {
            DispatchQueue.main.async {
                self.editorsChoiceRecipes = recipes
            }
        }
    }
    
    func importRecipeFromURL(){}
    
    func getAllRecipes() async {
        if let result: [Recipe] = loadJson(filename: "MockAllRecipes") {
            DispatchQueue.main.async {
                self.recipesToSearch = result
            }
        }
    }
}

//MARK: Shopping List
extension HomeScreenViewModel {
    //A function to pick which shopping list items to show in home screen
    func selectShoppingList() async {
        guard let selectedCategory else {return}
        if let result: SelectedShoppingList = await performNetworkRequest({
            try await networkService.sendRequest(endpoint: HomeScreenEndPoint.selectShoppingList(id: selectedCategory.id))
        }) {
            //homeScreenInfo?.items = selectedShoppingListItems
            selectedShoppingList = result
        }
    }
    
    func getSelectedList() async {
        if let result: SelectedShoppingList = loadJson(filename: "MockSelectedShoppingList") {
            DispatchQueue.main.async {
                self.selectedShoppingList = result
            }
        }
    }
    
    func tickItemInHome(itemId: Int) async {
        guard var selectedShoppingList = selectedShoppingList else { return }
        if let index = selectedShoppingList.items.firstIndex(where: { $0.id == itemId }) {
            selectedShoppingList.items[index].isCheck.toggle()
            var item = selectedShoppingList.items[index]
            
            await performNetworkRequest(skipLoading: true,{
                try await networkService.sendRequest(endpoint: ShoppingListEndPoint.updateItems(categoryID: selectedShoppingList.selectedShoppingCategory!.id, itemsIDs: [item.id]))
            })
        }
    }
    
    @MainActor func updateCategory(_ newCategory: ShoppingListCategory) {
        selectedCategory = newCategory
    }
    
    @MainActor func updateCategories(_ newCategories: [ShoppingListCategory]) {
        categories = newCategories
    }
}

//MARK: Scan Recipes - OCR
extension HomeScreenViewModel {
    func checkCameraAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            self.showScannerSheet = true
        case .notDetermined:
            // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showScannerSheet = true
                    }
                }
            }
            
        case .denied:
            // The user has previously denied access.
            alertMessage = AlertMessage(title: "Oops!", message: "To scan hard copied recipes you need to allow Camera acess in settings.")
            return
        case .restricted:
            // The user can't grant access due to restrictions.
            return
        @unknown default:
            return
        }
    }
    
    func scrapeRecipeDetails(recipeURL: String) async {
        if let result: RecipeWithCategories = try await performNetworkRequest({
            try await networkService.sendRequest(endpoint: RecipeEndPoint.getRecipeInfo(url: recipeURL))
        }) {
            recipeViewModel.recipeWithCategories = result
            recipeWithCategories  = result
        }
    }
    
    func getOcrRecipe(recipeText: String) async {
        if let chatGPTResponse: ChatGPTResponse = await performNetworkRequest({
            try await networkService.sendRequest(endpoint: ChatGPTEndPoint.convertRecipe(recipeText: recipeText))
        }) {
            if let content = chatGPTResponse.extractContent(),
               let cleanedData = cleanJSONString(content).data(using: .utf8) {
                do {
                    let recipeResponse = try JSONDecoder().decode(RecipeWithCategories.self, from: cleanedData)
                    DispatchQueue.main.async {
                        self.ocrRecipeWithCategories = recipeResponse
                        self.recipeViewModel.recipeWithCategories = self.ocrRecipeWithCategories
                        self.recipeViewModel.recipeWithCategories = recipeResponse
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.error = IdentifiableError(error: error)
                    }
                }
            } else {
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    private func cleanJSONString(_ jsonString: String) -> String {
        let cleanedString = jsonString
            .replacingOccurrences(of: "\\\"", with: "\"")
            .replacingOccurrences(of: "\\n", with: "")
            .replacingOccurrences(of: "\\", with: "")
        return cleanedString
    }
    
    func handleScannedText(textPerPage: [String]?) {
        if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
            recipeViewModel.recipeWithCategories = nil
            Task { await getOcrRecipe(recipeText: outputText) }
        }
        showScannerSheet = false
        showOcrRecipeSheet = true
    }
    
    func cancelScannerSheet() {
        showScannerSheet = false
        showOcrRecipeSheet = false
    }
}

extension HomeScreenViewModel {
    //for mock data project only :)
    func getCategories() -> [ShoppingListCategory] {
        if let fetchedCategories: [ShoppingListCategory] = loadJson(filename: "MockShoppingCategories") {
            DispatchQueue.main.async {
                self.categories = fetchedCategories
            }
        }
        return categories
    }
}


