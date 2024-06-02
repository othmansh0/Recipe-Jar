//
//  KeychainHelper.swift
//  PrivateDatabase
//
//  Created by Othman Shahrouri on 18/04/2024.
//
import Foundation
import Security
struct KeychainHelper {

    static let accessGroup = "group.com.othmanshahrouri.RecipeJar"

    @discardableResult
    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data,
            kSecAttrAccessGroup as String: accessGroup
        ] as [String : Any]

        SecItemDelete(query as CFDictionary) // Remove any existing item
        return SecItemAdd(query as CFDictionary, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne,
            kSecAttrAccessGroup as String: accessGroup
        ] as [String : Any]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        if status == noErr {
            return item as? Data
        }
        return nil
    }

    @discardableResult
    static func delete(key: String) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecAttrAccessGroup as String: accessGroup
        ] as [String : Any]

        return SecItemDelete(query as CFDictionary)
    }
}
