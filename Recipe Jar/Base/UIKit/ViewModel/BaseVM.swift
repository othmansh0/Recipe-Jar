//
//  BaseVM.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/04/2024.
//

import UIKit
import SwiftUI
@MainActor
class BaseVM: ObservableObject {
    @Published var error: IdentifiableError?
    @Published var alertMessage: AlertMessage?
    @Published var isLoading = false

    // Generic network request handler for returning data
    func performNetworkRequest<T>(skipLoading: Bool = false, skipErrors: Bool = false, _ request: () async throws -> T) async -> T? {
        if !skipLoading {
            isLoading = true
        }

        defer {
            if !skipLoading {
                isLoading = false
            }
        }
        
        do {
            return try await request()
        } catch let error {
            guard !skipErrors else { return nil }
            
            if let networkError = error as? NetworkError {
                self.error = IdentifiableError(error: networkError)
            } else {
                self.error = IdentifiableError(error: error)
            }
            return nil
        }
    }

    // Generic network request handler for non-returning actions
    func performNetworkAction(skipLoading: Bool = false, skipErrors: Bool = false, _ action: () async throws -> Void) async {
        if !skipLoading {
            isLoading = true
        }

        defer {
            if !skipLoading {
                isLoading = false
            }
        }
        
        do {
            try await action()
        } catch let error {
            guard !skipErrors else { return }
            
            if let networkError = error as? NetworkError {
                self.error = IdentifiableError(error: networkError)
            } else {
                self.error = IdentifiableError(error: error)
            }
        }
    }
    
    
    func loadJson<T: Decodable>(filename fileName: String, as type: T.Type = T.self) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            return decodedData
        }
        return nil
    }

}
