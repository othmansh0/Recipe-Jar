import Foundation

struct Folder: Codable, Nameable {
    var name: String
    var orderNumber: Int
    var recenltyRecipesAdded: [String]?
    var numberOfItems: Int?
    let id: Int

    enum CodingKeys: String, CodingKey {
        case name
        case orderNumber = "order_number"
        case numberOfItems = "number_of_items"
        case recenltyRecipesAdded = "recenlty_recipes_added"
        case id
    }
}

extension Folder {
    static func dummyFolders(count: Int) -> [Folder] {
        (0..<count).map { i in
            Folder(name: "Folder \(i)", orderNumber: i, recenltyRecipesAdded: ["onboarding_tab_2_1","onboarding_tab_3_2","onboarding_tab_3_1","defaultRecipeImage"], id: UniqueIDGenerator.generate())
        }
    }
}

