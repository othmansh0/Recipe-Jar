import Foundation
struct User: Codable {
    let userID: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case token = "token"
    }
}
