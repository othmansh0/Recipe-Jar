import Foundation
import SwiftUI
enum RecipeEndPoint {
    case getAllRecipes(categoryID: Int)
    case getRecipeInfo(url: String)
    case getRecipeIngredients(id: Int)
    case getRecipeSteps(id: Int)
    case saveRecipe(recipeWithCategories:RecipeWithCategories,selectedFolder:Folder,selectedList:ShoppingListCategory?,addToShoppingList: Bool,ingredientsArray:[[String : Any]]?,stepsArray:[[String : Any]]?)
    case deleteRecipe(id: Int)
    case createFolder(name: String)
    case renameFolder(categoryID: Int,name: String)
}

extension RecipeEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .getAllRecipes: return .get
        case .getRecipeInfo: return .get
        case .getRecipeIngredients(let id): return .get
        case .getRecipeSteps(let id): return .get
        case .deleteRecipe: return .delete
        case .createFolder: return .post
        case .renameFolder: return .put
        case .saveRecipe: return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllRecipes: return nil
        case .deleteRecipe(let id):
            return ["user_id": UserConfig.shared.appleID,"recipe_id": id]
        case .createFolder(let name):
           return ["user_id": UserConfig.shared.appleID,"category_name":name]
        case .renameFolder(let categoryID,let name):
            return ["user_id": UserConfig.shared.appleID,"category_id":categoryID,"new_name":name]
        case .getRecipeInfo:
           return nil
        case .saveRecipe(let recipeWithCategories, let selectedFolder, let selectedList,let addToShoppingList,let ingredientsArray,let stepsArray):
            return [
                "recipe_category_id": selectedFolder.id,
                "user_id": UserConfig.shared.appleID,
                "add_to_shopping_list": addToShoppingList,
                "shopping_list_category_id": selectedList?.id ?? nil,
                "recipe_name": recipeWithCategories.recipe.title,
                "recipe_time": recipeWithCategories.recipe.time ?? 0,
                "is_editor_choice": false,
                "image_url": recipeWithCategories.recipe.pictureUrl,
                "ingredients": ingredientsArray ?? [],
                "steps": stepsArray ?? [] ] as [String: Any]
        case .getRecipeIngredients:
            return nil
        case .getRecipeSteps:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllRecipes(let categoryID): return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID),URLQueryItem(name: "category_id", value: "\(categoryID)")]
            
        case .getRecipeInfo(let url):
            return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID),URLQueryItem(name: "website_url", value: url)]
            
        case .getRecipeIngredients(let id):
            return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID),URLQueryItem(name: "recipe_id", value: "\(id)")]
            
        case .getRecipeSteps(let id):
            return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID),URLQueryItem(name: "recipe_id", value: "\(id)")]
        default: return nil
        }
    }
    
    var host: String {
       return "dummyurl.com"
    }

    var scheme: String {
        return "https"
    }

    var path: String {
        switch self {
        case .getAllRecipes: return "/dummy/path/"
        case .deleteRecipe: return "/dummy/path/"
        case .createFolder: return "/dummy/path/"
        case .renameFolder: return "/dummy/path/"
        case .getRecipeInfo(url: let url): return "/dummy/path/"
        case .saveRecipe: return "/dummy/path/"
        
        case .getRecipeIngredients(id: let id):
            return "/dummy/path/"
        case .getRecipeSteps(id: let id):
            return "/dummy/path/"
        }
    }

    var header: [String: String]? {
        switch self {
        case .getAllRecipes:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .deleteRecipe:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .createFolder:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .renameFolder:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getRecipeInfo(url: let url):
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .saveRecipe:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getRecipeIngredients(id: let id):
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getRecipeSteps(id: let id):
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        }
    }
}

