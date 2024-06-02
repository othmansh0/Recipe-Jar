//
//  CloudKitManager.swift
//  PrivateDatabase
//
//  Created by Othman Shahrouri on 18/04/2024.
//

import Foundation
import CloudKit
import os.log
class CloudKitManager {
    
    /// Saves the given user ID and token for a user in the database only once.
    /// - Parameters:
    ///   - userID: User ID to attach to the record.
    ///   - token: Token to attach to the record.
    
    private let database: CKDatabase
    private let userRecordID: CKRecord.ID

    init(containerIdentifier: String, userRecordName: String) {
        let container = CKContainer(identifier: containerIdentifier)
        self.database = container.privateCloudDatabase
        self.userRecordID = CKRecord.ID(recordName: userRecordName)
    }

    /// Checks if the user record already exists in the database and returns the user if exists.
    func checkUserExists() async throws -> User? {
        do {
            let userRecord = try await database.record(for: userRecordID)
            
            if let userID = userRecord["userID"] as? String, let token = userRecord["token"] as? String {
                let user = User(userID: userID, token: token)
                return user
            } else {
                os_log("User record is missing userID or token.")
                return nil
            }
        } catch CKError.unknownItem {
            return nil  // Record does not exist
        } catch {
            return nil 
        }
    }

    /// Saves the given user ID and token for a user in the database.
    func saveUserInfo(user: User) async throws {
        let userRecord = CKRecord(recordType: "User", recordID: userRecordID)
        userRecord["userID"] = user.userID
        userRecord["token"] = user.token

        do {
            let (saveResults, _) = try await database.modifyRecords(saving: [userRecord],
                                                                    deleting: [],
                                                                    savePolicy: .allKeys)
            if let saveResult = saveResults.first(where: { $0.key == userRecordID })?.value {
                switch saveResult {
                case .success(let savedRecord):
                    os_log("Record with ID \(savedRecord.recordID.recordName) was saved.")
                case .failure(let error):
                    os_log("Failed to save record: %@", type: .error, error.localizedDescription)
                    throw error
                }
            } else {
                fatalError("Expected a saved record for ID \(userRecordID), but did not find one.")
            }
        } catch {
            throw error
        }
    }

    /// Deletes the user information from the database.
    func deleteUserInfo() async throws {
        do {
            let recordID = try await database.deleteRecord(withID: userRecordID)
            os_log("Record with ID \(recordID.recordName) was deleted.")
        } catch {
            throw error
        }
    }
}
