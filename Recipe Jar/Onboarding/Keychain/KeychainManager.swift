//
//  KeychainManager.swift
//  PrivateDatabase
//
//  Created by Othman Shahrouri on 18/04/2024.
//

import Foundation
import SwiftUI
class KeychainManager {
    // Constants for Keychain keys
    private let userIDKey = "userID"
    private let tokenKey = "token"

    /// Saves the userID and token in the Keychain.
    func saveCredentials(userID: String, token: String) {
        if let userIDData = userID.data(using: .utf8) {
            KeychainHelper.save(key: userIDKey, data: userIDData)
        }
        
        if let tokenData = token.data(using: .utf8) {
            KeychainHelper.save(key: tokenKey, data: tokenData)
        }
    }
    
    /// Fetches the userID and token from the Keychain.
    static func fetchCredentials() -> (userID: String?, token: String?) {
        let userID: String? = {
            if let userData = KeychainHelper.load(key: "userID") {
                return String(data: userData, encoding: .utf8)
            }
            return nil
        }()
        
        let token: String? = {
            if let tokenData = KeychainHelper.load(key: "token") {
                return String(data: tokenData, encoding: .utf8)
            }
            return nil
        }()
        
        return (userID, token)
    }
    
    /// Checks if the credentials exist in the Keychain.
    static func credentialsExist() -> Bool {
        let (userID, token) = fetchCredentials()
        return userID != nil && token != nil && UserDefaults.standard.bool(forKey: "log_status")
    }
    
    /// Deletes the userID and token from the Keychain.
    func deleteCredentials() {
        KeychainHelper.delete(key: userIDKey)
        KeychainHelper.delete(key: tokenKey)
    }
}


