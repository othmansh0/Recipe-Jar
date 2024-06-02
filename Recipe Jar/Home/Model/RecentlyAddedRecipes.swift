
import Foundation
struct RecentlyAddedRecipes: Codable {
    let recentlyAddedRecipes: [Recipe]
    enum CodingKeys: String, CodingKey {
        case recentlyAddedRecipes = "recently_added_recipes"
    }
}


