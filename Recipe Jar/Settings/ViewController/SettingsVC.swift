//
//  SettingsVC.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import UIKit
class SettingsVC: BaseVC {
    let vm = SettingsVM()
    var authVM: AuthViewModel!
    private var readyToObserveNotifications = false
    
    let navColor = UIColor(red: 0.984, green: 0.984, blue: 0.984, alpha: 1)
    
    init(authVM: AuthViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.authVM = authVM
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    @objc private func appDidBecomeActive() {
        //Code to handle what happens when the app becomes active
        vm.checkNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        vm.checkNotificationAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .titleOnly, buttonImageName: nil,backgroundColor:navColor )
        setNavigationBarTitle(titleIfRootVC: "Settings")
        
        hostSwiftUIView {
            SettingsScreen(vm: vm, authVM: authVM, notificationsTapped: toggleNotifications)
        }
    }
    
    
    private func toggleNotifications() {
        openSettings()
    }
    
    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url)
                return
            }
            responder = responder?.next
        }
    }
}
