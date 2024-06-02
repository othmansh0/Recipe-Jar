import Foundation
enum HomeScreenEndPoint {
    case getRecentlyAddedRecipes
    case getPickedRecipes
    case getSelectedShoppingList
    case selectShoppingList(id: Int)
    case getAllRecipes
   
}

extension HomeScreenEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .getRecentlyAddedRecipes: return .get
        case .getPickedRecipes: return .get
        case .selectShoppingList: return .post
        case .getSelectedShoppingList: return .get
        case .getAllRecipes: return .get
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getRecentlyAddedRecipes: return nil
        case .getPickedRecipes:
            return nil
//            return ["user_id": TempSinglton.shared.appleID]
            
        case .getSelectedShoppingList: return nil
        case .selectShoppingList(let id):
           return ["user_id": UserConfig.shared.appleID,"shopping_list_category_id":id]
        case .getAllRecipes:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getRecentlyAddedRecipes: return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
        case .getPickedRecipes: return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
        case .getSelectedShoppingList: return [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
        case .getAllRecipes: return [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
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
        case .getRecentlyAddedRecipes: return "/dummy/path/"
        case .getPickedRecipes: return "/dummy/path/"
        case .getSelectedShoppingList: return "/dummy/path/"
        case .selectShoppingList: return "/dummy/path/"
        case .getAllRecipes: return "/dummy/path/"
        }
    }

    var header: [String: String]? {
        switch self {
        case .getRecentlyAddedRecipes:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getPickedRecipes:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getSelectedShoppingList:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .selectShoppingList:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getAllRecipes:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        }
    }
}
