import Foundation
import SwiftUI
enum FolderEndPoint {
    case getAllFolders
    case deleteFolder(id: Int)
    case createFolder(name: String)
    case renameFolder(categoryID: Int,name: String)
}

extension FolderEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .getAllFolders: return .get
        case .deleteFolder: return .delete
        case .createFolder: return .post
        case .renameFolder: return .put
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .getAllFolders: return nil
        case .deleteFolder(let id):
            return ["user_id": UserConfig.shared.appleID,"category_id": id]
        case .createFolder(let name):
           return ["user_id": UserConfig.shared.appleID,"category_name":name]
        case .renameFolder(let categoryID,let name):
            return ["user_id": UserConfig.shared.appleID,"category_id":categoryID,"new_name":name]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getAllFolders: return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
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
        case .getAllFolders: return "/dummy/path/"
        case .deleteFolder: return "/dummy/path/"
        case .createFolder: return "/dummy/path/"
        case .renameFolder: return "/dummy/path/"
        }
    }

    var header: [String: String]? {
        switch self {
        case .getAllFolders:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .deleteFolder:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .createFolder:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .renameFolder:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        }
    }
}
