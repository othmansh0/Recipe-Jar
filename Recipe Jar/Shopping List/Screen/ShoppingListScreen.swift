import SwiftUI
import Combine

struct ShoppingListScreen: View {
    @ObservedObject var viewModel: ShoppingListViewModel
    @ObservedObject var selectedCategory: ShoppingListCategory
    
    @FocusState private var itemInFocus: FocusField?
    @State var itemsToCheckAvailability = [String]()
    
    
    
    //delete these later on by making the refactoring the list screen to take a binding items instead
//    @Binding var selectedShoppingList: SelectedShoppingList?
//    var isViewedFromHome: Bool = false
    var body: some View {
        BaseScreen(isLoading: [.constant(false)], error: $viewModel.error) {
            VStack (spacing:0){
                //MARK: Add Item Field
                CreateNewItemView(focus: _itemInFocus,
                                  foucsFieldType: .item,
                                  placeHolder: "Add New Item",
                                  isEnabled: $viewModel.isItemFieldEnabled,
                                  text: $viewModel.newItem,
                                  selectedEmoji: .constant(nil),
                                  changeFieldStatusAction: {viewModel.changeItemFieldStatus()},
                                  addAction: { await viewModel.createItem(categoryID:selectedCategory.id)},
                                  showEmojiPickerAction: nil)
                .padding(.horizontal,24)
                .padding(.top, 14)
                .padding(.bottom, 22)
                //MARK: shopping List
                ItemsListView(vm: viewModel)
                    .id(UUID())//selectedCategory.id)
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture { itemInFocus = nil }
            
            .onDisappear {
                viewModel.isListItemsRecieved = false
                Task{ await viewModel.toggleItemStatus() }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        itemInFocus = nil
                    }
                }
            }
            .onAppear{ viewModel.itemsToCheckAvailability = [] }
        }
        .task { await viewModel.getItems(categoryID: selectedCategory.id) }
//        .alert(viewModel.errorMessage,isPresented: $viewModel.showAlert){}
    }
}



extension UIApplication {
    func endEditing () {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



class ShoppingListItemsVC: BaseVC {
    
    var viewModel: ShoppingListViewModel!
    var selectedCategory: ShoppingListCategory!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .titleWithOneButton, buttonImageName: "")
        hostSwiftUIView { ShoppingListScreen(viewModel: viewModel, selectedCategory: selectedCategory) }
        //        subscribeToViewModelBlurEffect(shouldBlurPublisher: viewModel.$shouldBlur.eraseToAnyPublisher())
    }
    
    init(viewModel: ShoppingListViewModel,selectedCategory: ShoppingListCategory) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.selectedCategory = selectedCategory
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
}

//on appear check if selectedshopping list == selectedcategory if true selectedshoppinglist.items == items
