//
//  SceneDelegate.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 12/12/2023.
//

import UIKit
import SwiftUI
import Firebase
import Combine
class SceneDelegate: UIResponder, UIWindowSceneDelegate,AppCoordinatorDelegate {
    
    @AppStorage("log_status") var log_status = false
    @AppStorage("userID") var userID = UUID().uuidString
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let vm = AuthViewModel()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = log_status ? createMainTabControllerVC(authVM: vm) : createOnBoardingNC(authVM: vm)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func createOnBoardingNC(authVM: AuthViewModel) -> UINavigationController {
        let vc = OnBoardingViewController(authVM: authVM, createMainTabController: createMainTabControllerVC)
        return UINavigationController(rootViewController: vc)
    }
    
    func createMainTabControllerVC(authVM: AuthViewModel) -> UIViewController {
        let vc = MainTabController()
        vc.appCoordinatorDelegate = self
        return vc
    }
    
    func navigateToOnboarding(authVM: AuthViewModel) {
        let onboardingViewController = createOnBoardingNC(authVM: authVM)
        window?.rootViewController = onboardingViewController
        window?.makeKeyAndVisible()
    }
}

protocol AppCoordinatorDelegate: AnyObject {
    func navigateToOnboarding(authVM: AuthViewModel)
}
