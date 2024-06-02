import Foundation
import SwiftUI

enum ShoppingListEndPoint {
    case getAllCategories
    case deleteCateogry(id: Int)
    case createCategory(newCategoryName: String,newCategoryIcon:String)
    case renameCategory(categoryID: Int,newName: String,newIcon: String)
    
    case getItems(categoryID: Int)
    case addItem(categoryID: Int, name: String)
    case deleteItem(categoryID: Int,itemId: Int)
    case updateItems(categoryID: Int,itemsIDs: [Int])
    
}
//
extension ShoppingListEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .getAllCategories: return .get
        case .deleteCateogry: return .delete
        case .createCategory: return .post
        case .renameCategory: return .put
            
        case .getItems: return .get
        case .addItem: return .post
        case .deleteItem: return .delete
        case .updateItems: return .put
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllCategories: return nil
        case .deleteCateogry(let id):
            return ["user_id": UserConfig.shared.appleID,"shopping_list_category_id": id]
        case .createCategory(let newCategoryName,let newCategoryIcon):
           return ["user_id": UserConfig.shared.appleID,"name":newCategoryName,"icon":newCategoryIcon]
            
            
        case .renameCategory(let categoryID,let newName, let newIcon):
            return ["user_id": UserConfig.shared.appleID,"shopping_list_category_id":categoryID,"name":newName,"icon":newIcon]
            
        case .getItems(let categoryID):
            return nil
            
        case .addItem(let categoryID,let name):
            return ["user_id": UserConfig.shared.appleID,"shopping_list_category_id":categoryID,"item_name":name]
       
        case .deleteItem(let categoryID, let itemID):
            return ["user_id": UserConfig.shared.appleID,"shopping_list_category_id":categoryID,"item_id":itemID]

        case .updateItems(let categoryID,let itemsIDs):
            return ["shopping_list_category_id":categoryID,"items":itemsIDs]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllCategories: return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
            
           
        case .getItems(let categoryID):
            return [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID), URLQueryItem(name: "shopping_list_category_id", value: "\(categoryID)")]
            
//        case .deleteItem(let categoryID, let itemID):
        default: return nil
//        case .deleteCateogry: return nil
//        case .createCategory: return nil
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
        case .getAllCategories: return "/dummy/path/"
        case .deleteCateogry: return "/dummy/path/"
        case .createCategory: return"/dummy/path/"
        case .renameCategory: return "/dummy/path/"
           
        case .getItems(let categoryID):
            return "/dummy/path/"
        case .addItem(let categoryID, let name):
            return "/dummy/path/"
     
        case .deleteItem(let categoryID,let itemId):
            return "/dummy/path/"
        case .updateItems:
            return "/dummy/path/"
        }
    }

   

    var header: [String: String]? {
        switch self {
        case .getAllCategories:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .deleteCateogry:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .createCategory:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .renameCategory:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .getItems:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .addItem(categoryID: let categoryID, name: let name):
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .deleteItem(categoryID: let categoryID, itemId: let itemId):
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .updateItems:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        }
    }
}




