//
//  OnBoardingViewController.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 20/04/2024.
//

import UIKit
import Combine
class OnBoardingViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    
    var authVM: AuthViewModel
    var createMainTabController: CreateMainTabControllerVCType
    
    init(authVM: AuthViewModel, createMainTabController: @escaping CreateMainTabControllerVCType) {
        self.authVM = authVM
        self.createMainTabController = createMainTabController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeForUserRegisteration()
        hostSwiftUIView(topConstant: 0) {  OnboardingScreen(vm: authVM) }
    }
    
    func observeForUserRegisteration() {
        authVM.$isUserRegistered
            .sink { [weak self] isReceived in
                guard let self = self else { return }
                if isReceived {
                    navigationController?.isNavigationBarHidden = true
                    navigationController?.pushViewController(self.createMainTabController(authVM), animated: true)
                }
            }
            .store(in: &cancellables)
    }
}
typealias CreateMainTabControllerVCType = (AuthViewModel) -> UIViewController
