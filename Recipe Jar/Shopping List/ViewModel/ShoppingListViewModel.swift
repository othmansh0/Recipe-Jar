import Foundation
import SwiftUI
@MainActor
class ShoppingListViewModel:BaseVM {
    
    @Published var isCategoriesRecieved = false
    @Published var isListItemsRecieved = false
    @Published var shouldBlur: Bool = false
    
    private var networkService: Networkable
   
    init(networkService: Networkable = NetworkService()) {
        self.networkService = networkService
    }
    
    @Published var selectedCategory = ShoppingListCategory(id: -1, name: "", icon: "", numberOfItems: -1, orderNumber: -1)
    @Published var deletedCategoryID: Int?
    
    
    @Published var homeWidgetCategory: ShoppingListCategory?

    
    @Published var selectedEmoji: Emoji?
    @Published var isEmojiPickerDisplayed: Bool = false
    @Published var category = ""
    @Published var isCategoryFieldEnabled = false
    @Published var addPressed = false
    
    
    @Published  var presentAlert = false
    @Published var showDeleteMenu = false
    @Published var showRenameMenu = false
    @Published var renameCategory = ""
    @Published  var isRenamePresented = false
    
    @Published var newItem = ""
    @Published var isItemFieldEnabled = false
    @Published var tempItemsIDs = [Int]()//temp array to know which items have been changed so they can be updated in the database
    
    
    @Published var itemUpdated = false
    
    
    //1- add item => set a flag to true then if selectedcategory in dashboard vm and should is
    
    
    
    
    
    
    @Published var itemToDelete = ShoppingListItem(id: -1, name: "", isCheck: false) //temp array to know which items have been changed so they can be updated in the database
    @Published var itemsToCheckAvailability = [String]()
    
    @Published var isTabBarVisibile = true
    
    
    @Published var categories = [ShoppingListCategory]()
    @Published var items = [ShoppingListItem]()
    func changeCategoryFieldStatus(){
        if category.isEmpty {isCategoryFieldEnabled = false}
        else {isCategoryFieldEnabled = true}
    }
    
    
    func changeItemFieldStatus(){
        if newItem.isEmpty {isItemFieldEnabled = false}
        else {isItemFieldEnabled = true}
    }
    
    
    func deleteListsPressed(){
        presentAlert = true
        withAnimation(.popUpAnimation()) { showDeleteMenu = true }
        shouldBlur = true
    }
   
    func renameListPressed(){
        withAnimation(.popUpAnimation()) { showRenameMenu = true }
        shouldBlur = true
    }
    
    func deleteCategory() async {
        showDeleteMenu = false
        shouldBlur = false
        deletedCategoryID = selectedCategory.id
        categories.removeAll { $0.id == selectedCategory.id }
//        if selectedCategory.id == cate
        await performNetworkRequest(skipLoading: true,skipErrors: true,{
                try await networkService.sendRequest(endpoint: ShoppingListEndPoint.deleteCateogry(id: selectedCategory.id))
            })
    }
    
    func renameCategory() async {
        showRenameMenu = false
        shouldBlur = false
        await performNetworkRequest(skipLoading: true,{
                try await networkService.sendRequest(endpoint: ShoppingListEndPoint.renameCategory(categoryID: selectedCategory.id, newName: renameCategory, newIcon: selectedCategory.icon ?? "🗂️"))
            })
        renameCategory = ""
    }
    
    func createCategory() async -> ShoppingListCategory? {
        if category != ""{
            //append object locally then remove it when creating category API returns the real object
            let tempCategory = ShoppingListCategory(id: -1, name: category, icon: selectedEmoji?.value ?? "🗂️", numberOfItems: 0, orderNumber: -1)
            
            categories.append(tempCategory)
            let tempCategoryName = category
            let tempEmoji = selectedEmoji?.value ?? "🗂️"
            category = ""
            selectedEmoji = nil
            changeCategoryFieldStatus()
           
            
            if let createdCategory: ShoppingListCategory = await performNetworkRequest(skipLoading: true,{
                try await networkService.sendRequest(endpoint: ShoppingListEndPoint.createCategory(newCategoryName: tempCategoryName, newCategoryIcon: tempEmoji))
            }) {
            categories.removeLast()
            categories.append(createdCategory)
            return createdCategory
            }
//            
           
            //OrderID should be editted and dyanmic
        }
        return nil
    }
    

    
    
    func getCategories() async -> [ShoppingListCategory] {
           if let fetchedCategories: [ShoppingListCategory] = loadJson(filename: "MockShoppingCategories") {
               DispatchQueue.main.async {
                   self.categories = fetchedCategories
//                   self.isCategoriesRecieved = true
               }
           }
           return categories
       }

}



extension ShoppingListViewModel {
    
    func getItems(categoryID: Int?) async -> [ShoppingListItem] {
        guard let categoryID else { return [] }
        
        if let fetchedItems: [ShoppingListItem] = await performNetworkRequest({
            try await networkService.sendRequest(endpoint: ShoppingListEndPoint.getItems(categoryID: categoryID))
        }) {
            
            items = fetchedItems
        }
        return items
    }

    
    func tickItem( item:inout ShoppingListItem) {
        itemUpdated = true
        item.isCheck.toggle()
        
        //When item status change,check if it exist in temp array or not if it does then remove it as it means the item state returned to its original state
        //so there's no need to include it in our API ex: checked => unchecked => checked
        //if item doesnt exist then add it
        if let index = tempItemsIDs.firstIndex(where: {$0 == item.id}) {
            tempItemsIDs.remove(at: index)
        }else{
            tempItemsIDs.append(item.id)
        }
    }
    
    func tickItem(itemId: Int) {
        itemUpdated = true
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            items[index].isCheck.toggle()
        }
    }
    
    func toggleItemStatus() async {
        itemUpdated = true
        await performNetworkRequest(skipLoading: true,{
            try await networkService.sendRequest(endpoint: ShoppingListEndPoint.updateItems(categoryID: selectedCategory.id, itemsIDs: tempItemsIDs))
        })
            tempItemsIDs = [Int]()
    }
    
    //needs categoryID as we cant use selectedCategory object it'll always be nill when navigating from categories screen to items screen
    func createItem(categoryID: Int) async {
        if newItem != ""{
            itemUpdated = true
            //append object locally then remove it when creating item API returns the real object
            let tempItem = ShoppingListItem(id: -1, name: newItem, isCheck: false)//, orderNumber: items.count+1)
            items.append(tempItem)
            let tempItemName = newItem
            newItem = ""
            
            if let createdItem: ShoppingListItem = await performNetworkRequest(skipLoading: true,{
                try await networkService.sendRequest(endpoint: ShoppingListEndPoint.addItem(categoryID: categoryID, name: tempItemName))
            }) {
                items.removeLast()
                items.append(createdItem)
            }
            newItem = ""
        }
    }
    
    func deleteItem() async {
        itemUpdated = true
        showDeleteMenu = false
        items.removeAll(where: { $0.id == itemToDelete.id })
        await performNetworkRequest(skipLoading: true,skipErrors: true,{
            try await networkService.sendRequest(endpoint: ShoppingListEndPoint.deleteItem(categoryID: selectedCategory.id , itemId: itemToDelete.id))
        })
    }
    
    func getUncheckedItems() async {
        //filter method to get an array of unchecked objects,then map method to create a new array containing just the name properties of those objects
        itemsToCheckAvailability = items.filter{ $0.isCheck == false}.map{$0.name}
    }
    
    @MainActor func updateCategory(_ newCategory: ShoppingListCategory) {
        selectedCategory = newCategory
    }
}
