//
//  HomeVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/03/2024.
//

import UIKit
import UserNotifications
class HomeVC: BaseVC {
    var vm: HomeScreenViewModel!
    var shoppingListVM: ShoppingListViewModel!

    private var notificationManager: NotificationManager!
    private var sideMenuViewController: SideMenuViewController!
    private var tapOutsideGestureRecognizer: UITapGestureRecognizer!
    private var overlayView: UIView!  // View to intercept taps when the side menu is open
    
    let folderViewModel = FolderViewModel()
        
    init(homeViewModel: HomeScreenViewModel,shoppingListVM: ShoppingListViewModel,notificationManager: NotificationManager) {
        super.init(nibName: nil, bundle: nil)
        self.vm = homeViewModel
        self.shoppingListVM = shoppingListVM
        self.notificationManager = notificationManager
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .root, buttonImageName: nil)
        requestNotificationPermission()
        hostSwiftUIView {
            HomeScreen(vm: vm, folderViewModel: folderViewModel, shoppingListVM: shoppingListVM, showRecipe: {[weak self] recipe in self?.showRecipeDetail(selectedRecipe: recipe)}, showFAQ: {[weak self] in  self?.showHelpVC()}, showShoppingList: {self.showShoppingListItemsVC()})
                .ignoresSafeArea()
        }
        setupOverlayView()
        setupSideMenu()
        
        vm.$showSideMenu
            .sink { [weak self] isReceived in
                guard let self = self else { return }
                adjustSideMenuVisibility(shouldShow: isReceived)
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: !vm.showSideMenu)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setNavigationBarTitle(titleIfRootVC: "RECIPE JAR")
    }
        
    override func leftButtonAction() { vm.showSideMenu = true }
    
    override func rightButtonAction() {
        vm.checkCameraAuthorizationStatus()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setNavigationBarTitle(titleIfRootVC: "RECIPE JAR")
        // Ensure the overlay view's frame is updated to match the parent view's bounds
        //        Ensure the View is Fully Initialized: Ensure overlayView is fully initialized with the correct frame before trying to animate it. If the view is being set up in viewDidLoad, its frame might not yet be fully defined to match the parent view's bounds.
        overlayView.frame = view.bounds
    }


    private func requestNotificationPermission() {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            notificationManager.requestAuthorization(options: authOptions) { granted, error in
                if granted {}
                else if let error = error {}
            }
        }
}

//MARK: Navigators
extension HomeVC {
    func showRecipeDetail(selectedRecipe: Recipe) {
        let vc = RecipeDetailVC(homeViewModel: vm, recipeToShow: selectedRecipe)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showHelpVC() {
        DispatchQueue.main.async {
              let vc = FAQVC(expandQuestion1: true)
              self.navigationController?.pushViewController(vc, animated: true)
          }
    }
    
    func showShoppingListItemsVC() {
        DispatchQueue.main.async {
            guard let selectedCategory =  self.vm.selectedCategory else { return }
            let vc = ShoppingListItemsVC(viewModel: self.shoppingListVM, selectedCategory:  selectedCategory)
            vc.selectedCategory = selectedCategory
            vc.customNavBar.titleLabel.text = selectedCategory.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: Side Menu
extension HomeVC {
    private func setupOverlayView() {
        overlayView = UIView(frame: self.view.bounds)
        overlayView.backgroundColor = UIColor(red: 0.217, green: 0.217, blue: 0.217, alpha: 0.56)
        overlayView.isHidden = true
        overlayView.alpha = 0
        view.addSubview(overlayView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSideMenu))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    func showOverlay(completion: (() -> Void)? = nil) {
        overlayView.isHidden = false
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 1
        }, completion: { finished in
            if finished {
                completion?()
            }
        })
    }
    
    func hideOverlay(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
        }, completion: { finished in
            if finished {
                self.overlayView.isHidden = true
                completion?()
            }
        })
    }
    
    
    @objc private func dismissSideMenu() { hideSideMenu() }
    
    private func setupSideMenu() {
        sideMenuViewController = SideMenuViewController(folders: folderViewModel.folders, categories: vm.categories, shoppingListVM: shoppingListVM, homeViewModel: vm)
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
    }
    
    private func adjustSideMenuVisibility(shouldShow: Bool) { shouldShow ? showSideMenu() : hideSideMenu() }

    private func showSideMenu() {
        view.bringSubviewToFront(overlayView)
        let newSideMenuViewController = SideMenuViewController(folders: folderViewModel.folders, categories: vm.categories, shoppingListVM: shoppingListVM, homeViewModel: vm)
        if sideMenuViewController != nil {
            sideMenuViewController?.willMove(toParent: nil)
            sideMenuViewController?.view.removeFromSuperview()
            sideMenuViewController?.removeFromParent()
        }
        sideMenuViewController = newSideMenuViewController
        addChild(sideMenuViewController!)
        view.addSubview(sideMenuViewController!.view)
        sideMenuViewController!.didMove(toParent: self)
        
        view.bringSubviewToFront(sideMenuViewController!.view)
        
        adjustTabBarVisibility(shouldShow: false)
        sideMenuViewController!.showMenu(completion: {
            self.showOverlay()
        })
    }
    
    private func hideSideMenu() {
        sideMenuViewController?.hideMenu(completion: { [weak self] in
            guard let self = self else { return }
            self.sideMenuViewController?.willMove(toParent: nil)
            self.sideMenuViewController?.view.removeFromSuperview()
            self.sideMenuViewController?.removeFromParent()
            self.sideMenuViewController = nil  // Remove the reference to allow re-creation with updated data
            self.adjustTabBarVisibility(shouldShow: true)
            vm.showSideMenu = false
            self.hideOverlay()
        })
    }
}


protocol NotificationManager {
    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void)
}
class DefaultNotificationManager: NotificationManager {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
        center.requestAuthorization(options: options, completionHandler: completionHandler)
        
    }
}
