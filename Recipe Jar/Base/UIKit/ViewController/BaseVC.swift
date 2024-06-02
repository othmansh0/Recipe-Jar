//
//  BaseVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 22/12/2023.
//

import UIKit
import Combine
class BaseVC: UIViewController {
    var blurEffectView: UIVisualEffectView!
    var cancellables: Set<AnyCancellable> = []
    let customNavBar = CustomNavigationBar(title: "", subtitle: "s")
    private static var previousVCTitle: String?
    var navigationBarTitle2: String?
    var navigationBarTitle: String? {
        get { return customNavBar.titleLabel.text }
        set { customNavBar.titleLabel.text =  newValue }
    }
    
    var isRootVC: Bool {
        if let navigationController = self.navigationController, self == navigationController.viewControllers.first {
            return true
        } else {
            return false
        }
    }
    
    func setNavigationBarColor(color: UIColor? = UIColor(hex: "F8F8F8") ){
        view.backgroundColor = color
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarColor()
        navigationController?.navigationBar.isHidden = true
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let previousViewController = navigationController?.viewControllers.dropLast().last as? BaseVC {
            BaseVC.previousVCTitle = previousViewController.navigationBarTitle2
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isRootVC { hideBackButton() }
    }
    
   
    
    
    func customNavigationBarDidTapBackButton() { navigationController?.popViewController(animated: true) }
    func hideBackButton() { customNavBar.backButton?.isHidden = true }
    func hideNavigationBar() { customNavBar.isHidden = true  }
    func showNavigationBar() { customNavBar.isHidden = false  }
    
    private func setupNavigationBar() {
        view.addSubview(customNavBar)
        NSLayoutConstraint.activate([
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: UIScreen.screenHeight*0.14084507)//60)//UIScreen.screenHeight * 0.07042254)
        ])
        customNavBar.delegate = self
    }
    
    func setNavigationBarStyle(to navigationStyle: CustomNavigationStyle,buttonImageName: String?,isYouTubeDisabled: Bool = false,backgroundColor: UIColor? = nil,menuActions: [UIAction]? = nil,overridenDetailTitle: String? = nil,buttonTitle: String? = nil) {
        customNavBar.setNavigationStyle(to: navigationStyle, buttonImageName: buttonImageName,isYouTubeDisabled: isYouTubeDisabled,backgroundColor:backgroundColor,menuActions: menuActions,overridenDetailTitle: overridenDetailTitle, buttonTitle: buttonTitle)
    }
    
    
    func setNavigationBarTitle(titleIfRootVC: String?) {
        navigationBarTitle2 = titleIfRootVC
        if let title = BaseVC.previousVCTitle {
            navigationBarTitle = isRootVC ? titleIfRootVC : title
        }
        else {
            navigationBarTitle = titleIfRootVC
        }
    }

}

// MARK: - CustomNavigationBarDelegate
extension BaseVC: CustomNavigationBarDelegate {
    @objc func leftButtonAction() {
    }
    @objc func rightButtonAction() {
    }
    
    @objc func firstItemAction() {
    }
    
    @objc func secondItemAction() {
    }
    
    @objc func thirdItemAction() {
    }
    
    @objc func fourthItemAction() {
    }
        
}


//MARK: Pop-ups

extension BaseVC {
    /// Toggles a blur effect overlay on the navigation bar since it's UIKit while Pop-UP is SwiftUI.
    /// - Parameter shouldShow: A Boolean value indicating whether the blur effect should be shown or removed.
     func toggleBlurEffect(shouldShow: Bool) {
        if shouldShow {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = customNavBar.bounds // Adjust to customNavBar bounds

            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.blurEffectView = blurEffectView
            view.addSubview(blurEffectView)
            blurEffectView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                blurEffectView.alpha = 0.2
            }
        } else {
            guard let blurEffectView = blurEffectView else { return }
            UIView.animate(withDuration: 0.3, animations: {
                blurEffectView.alpha = 0
            }) { _ in
                blurEffectView.removeFromSuperview()
            }
        }
    }    
    
    
    func subscribeToViewModelBlurEffect(shouldBlurPublisher: AnyPublisher<Bool, Never>) {
        shouldBlurPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldBlur in
                self?.toggleBlurEffect(shouldShow: shouldBlur)
            }
            .store(in: &cancellables)
    }
}

