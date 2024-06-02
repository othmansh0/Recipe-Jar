import Foundation
enum AuthEndPoint {
    case checkIfUserExist
    case createUser
    case deleteUser
}

extension AuthEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .checkIfUserExist: return .get
        case .createUser: return .post
        case .deleteUser: return .delete
        }
    }
    
    var body: [String : Any]? {
        switch self {
            
        case .checkIfUserExist:
            return [:]
        
        case .createUser:
            return [:]
        case .deleteUser:
            return ["user_id": UserConfig.shared.appleID]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .checkIfUserExist:  return  [URLQueryItem(name: "user_id", value: UserConfig.shared.appleID)]
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
        case .checkIfUserExist: return "/dummy/path/"
        case .createUser: return "/dummy/path/"
        case .deleteUser: return "/dummy/path/"
        }
    }

    var header: [String: String]? {
        switch self {
        case .createUser:
            return [:]
        case .deleteUser:
            return ["Authorization": "Token \(UserConfig.shared.tempToken)"]
        case .checkIfUserExist:
            return [:]
        }
    }
}

