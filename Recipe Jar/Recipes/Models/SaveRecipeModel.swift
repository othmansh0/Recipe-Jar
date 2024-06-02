import Foundation
class SaveRecipeModel: Codable {
    let recipeCategoryID: String
    let userID: String
    let addToShoppingList: Bool
    let shoppingListCategoryID: String
    let name: String
    let time: Int
    let pictureUrl: String
    let isEditorChoice: Bool
    let ingredients: [Ingredient]
    let steps: [Step]

    enum CodingKeys: String, CodingKey {
        case recipeCategoryID = "recipe_category_id"
        case userID = "user_id"
        case addToShoppingList = "add_to_shopping_list"
        case shoppingListCategoryID = "shopping_list_category_id"
        case name
        case time
        case pictureUrl = "picture_url"
        case isEditorChoice = "is_editor_choice"
        case ingredients
        case steps
    }
}
