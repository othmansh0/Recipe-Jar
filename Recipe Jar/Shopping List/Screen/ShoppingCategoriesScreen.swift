import SwiftUI
//import EmojiPicker
struct ShoppingCategoriesScreen: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    let showShoppingListScreen: (ShoppingListCategory) -> Void
    @FocusState private var categoryFocus: FocusField?
    
    var body: some View {
        BaseScreen(isLoading: [.constant(false)], error: $viewModel.error,backgroundColor: .white) {
            ZStack {
                VStack (alignment: .leading,spacing:10) {
                    //MARK: Create Category Field
                    CreateNewItemView(focus: _categoryFocus,
                                      foucsFieldType: .category,
                                      placeHolder: "Create New Category",
                                      isEnabled: $viewModel.isCategoryFieldEnabled,
                                      text: $viewModel.category,
                                      selectedEmoji: $viewModel.selectedEmoji,
                                      changeFieldStatusAction: {viewModel.changeCategoryFieldStatus()},
                                      addAction:  {  _ = await viewModel.createCategory()},
                                      showEmojiPickerAction: {viewModel.isEmojiPickerDisplayed.toggle()})
                    
                    .padding(.top, 14)
                    .padding(.bottom, 22)
                    
                    //MARK: Categories
                    ShoppingCategoriesListView(categories: viewModel.isLoading ? ShoppingListCategory.dummyCategories(count: 6) : viewModel.categories, showShoppingListScreen: showShoppingListScreen)
                        .id(UUID())
                        .onTapGesture { categoryFocus = nil }
                        .redactShimmer(condition: viewModel.isLoading)
                        .disabled(viewModel.isLoading)
                    
                }
                .padding(.horizontal,24)
                popUpWithBlurView(title: "Delete List",
                                  detail: "Select the list you want to delete",
                                  isActive: $viewModel.showDeleteMenu,
                                  shouldBlur: $viewModel.shouldBlur,
                                  selectedItem: $viewModel.selectedCategory,
                                  items: viewModel.categories,
                                  tapAction: {await viewModel.deleteCategory()},
                                  tapOutsideAction: {
                    viewModel.showDeleteMenu = false
                    viewModel.shouldBlur = false})
                popUpWithBlurView(title: "Rename List",
                                  detail: "Select the list you want to Rename",
                                  isActive: $viewModel.showRenameMenu,
                                  shouldBlur: $viewModel.shouldBlur,
                                  selectedItem: $viewModel.selectedCategory,
                                  items: viewModel.categories,
                                  tapAction: { viewModel.isRenamePresented = true },
                                  tapOutsideAction: {
                    viewModel.showRenameMenu = false
                    viewModel.shouldBlur = false})
                .alert("Rename",isPresented: $viewModel.isRenamePresented){
                    TextField("New name",text: $viewModel.renameCategory)
                    Button("Rename"){
                        viewModel.selectedCategory.name = viewModel.renameCategory
                        viewModel.categories[viewModel.selectedCategory.orderNumber-1].name = viewModel.renameCategory
                        Task { await viewModel.renameCategory() }
                    }
                    Button("Cancel", role: .cancel, action: { viewModel.renameCategory = "" })
                }
            }
            .onFirstAppearAsync { await viewModel.getCategories() }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        categoryFocus = nil //false
                    }
                }
            }
            .sheet(isPresented: $viewModel.isEmojiPickerDisplayed) {
                NavigationView {
                    EmojiPickerView(selectedEmoji: $viewModel.selectedEmoji, selectedColor: .orange,emojiProvider: LimitedEmojiProvider())
                        .navigationTitle("Emojis")
                        .navigationBarTitleDisplayMode(.inline)
                    //                    .navigationBarDrawer(displayMode: .always)
                }
            }
        }
    }
}

final class LimitedEmojiProvider: EmojiProvider {
    func getAll() -> [Emoji] {
        @State var emojisObj = EmojiManager()
        var emojisToDisplay = [Emoji]()
        //converting emoji object from json file to emoji picker object
        //and filtering emojis to be food and drink only
        for emoji in emojisObj.emojis.filter({$0.group == .foodAndDrink}) {
            emojisToDisplay.append(Emoji(value: emoji.char , name: emoji.name))
        }
        return emojisToDisplay
    }
}
enum FocusField: Hashable,CaseIterable {
    case category
    case item
}



