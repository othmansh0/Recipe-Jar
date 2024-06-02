//
//  AppDelegate.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 12/12/2023.
//

import UIKit
import Firebase
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
        
        // Set Messaging delegate
//        Messaging.messaging().delegate = self
        
        // Register for remote notifications
//        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}

// Cloud Messaging
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        let dataDict: [String: String] = ["token": fcmToken ?? ""]
//    print("dataDict is \(dataDict)")
//    }
//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
//      -> UIBackgroundFetchResult {
//
//          print("userinfo\(userInfo)")
//        return UIBackgroundFetchResult.newData
//    }
//}
