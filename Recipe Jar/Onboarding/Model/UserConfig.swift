import Foundation
class UserConfig {
    static let shared = UserConfig()

    // Make tempToken and appleID computed properties
    private(set)  var tempToken = KeychainManager.fetchCredentials().token ?? ""
    private(set)  var appleID = KeychainManager.fetchCredentials().userID ?? ""
    
    
    /// Only needed the first time the user creates
     func fillUserSingleton(user: User) {
       tempToken = user.token
       appleID = user.userID
    }

    private init() {}
}
