import Foundation
struct SelectedShoppingList: Identifiable, Codable {
    let id = UUID().uuidString
    var selectedShoppingCategory: ShoppingListCategory?
    var items: [ShoppingListItem]
    enum CodingKeys: String, CodingKey {
        case selectedShoppingCategory = "selected_shopping_category"
        case items
    }
}
