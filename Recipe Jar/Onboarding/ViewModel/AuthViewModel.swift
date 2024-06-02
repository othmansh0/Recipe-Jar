
import Foundation
import Firebase
import os.log
import SwiftUI
/// Our class primarily sets properties for the UI, so the entire model is in the MainActor context
@MainActor class AuthViewModel: BaseVM {
    
    @AppStorage("log_status") var isLoggedIn: Bool = false
    @Published var currentUser: User?
    @Published var isUserRegistered = false
    
    private var networkService: Networkable
    
    ///nonisolated: Allows the initializer to execute code that doesn’t strictly adhere to the MainActor's requirement of running on the main thread, enabling it to kick off asynchronous tasks.
    init(networkService: Networkable = NetworkService() ) {
        self.networkService = networkService
    }

    func checkForUser(){
        createUser()
//        updateUserSession(with: User(userID: "dummyUser", token: "dummyToken"))
    }
    
    func createUser() {
        isUserRegistered = true
        logIn()
    }
    

    private func updateUserSession(with user: User) {
        UserConfig.shared.fillUserSingleton(user: user)
        isUserRegistered = true
        logIn()
    }
    
    
    func deleteUser() async {
//        try? await networkService.sendRequest(endpoint: AuthEndPoint.deleteUser)
        isUserRegistered = false
        logOut()
    }
}


//MARK: Log In status
extension AuthViewModel {
    func logIn() { isLoggedIn = true }
    func logOut() { isLoggedIn = false }
}
