//
//  SettingsVM.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 11/04/2024.
//

import SwiftUI
@MainActor
class SettingsVM: BaseVM {

    @Published var isNotificationsEnabled: Bool = false
    @Published var initialCheckDone: Bool = false
    
    func checkNotificationAuthorization() {
         UNUserNotificationCenter.current().getNotificationSettings { settings in
             DispatchQueue.main.async {
                 switch settings.authorizationStatus {
                 case .authorized, .provisional:
                     self.isNotificationsEnabled = true
                 case .denied, .notDetermined,.ephemeral:
                     self.isNotificationsEnabled = false
                 @unknown default:
                     self.isNotificationsEnabled = false
                 }                 
             }
         }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.initialCheckDone = true
        }
     }
    
    func defaultEmailBody() -> String {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        let iosVersion = UIDevice.current.systemVersion
        let region = Locale.current.regionCode ?? "Unknown"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let currentDate = dateFormatter.string(from: Date())

        return """
        App Version: \(appVersion) (\(appBuild))
        Date: \(currentDate)
        iOS Version: \(iosVersion)
        Region: \(region)
        """
    }
    
}


