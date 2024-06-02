//
//  MainTabController.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/12/2023.
//

import UIKit
import Combine

protocol TabSelectionDelegate: AnyObject {
    func selectTab(atIndex index: Int)
}

class MainTabController: UITabBarController, UITabBarControllerDelegate, TabSelectionDelegate {
    private var cancellables: Set<AnyCancellable> = []
    weak var appCoordinatorDelegate: AppCoordinatorDelegate?
    var underlineView: UIView?
    
    var authVM = AuthViewModel()
    let tabBarHeight = 83.0
    let borderHeight: CGFloat = 1.0
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tabBar.isHidden { return }
        var tabFrame = tabBar.frame
        tabFrame.size.height = tabBarHeight
        tabFrame.origin.y = view.frame.size.height - tabBarHeight
        tabBar.frame = tabFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        observeForUserRegisteration()
        //guard let userID = KeychainManager.fetchCredentials().userID, let token = KeychainManager.fetchCredentials().token else { return }
        UserConfig.shared.fillUserSingleton(user: User(userID: "", token: ""))
        setupTabs()
        addUnderlineToSelectedTab()
    }
    
    func observeForUserRegisteration() {
        authVM.$isUserRegistered
            .sink { [weak self] isReceived in
                guard let self = self else { return }
                if !isReceived {
                    appCoordinatorDelegate?.navigateToOnboarding(authVM: authVM)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupTabs() {
        let homeViewModel = HomeScreenViewModel()
        let shoppingListVM = ShoppingListViewModel()
        let tab1 = createTabNC(vc: HomeVC(homeViewModel: homeViewModel, shoppingListVM: shoppingListVM, notificationManager: DefaultNotificationManager()),tabType: .home)
        let tab2 = createTabNC(vc: ShoppingCategoriesVC(shoppingListVM: shoppingListVM),tabType: .shoppingList)
        let tab3 = createTabNC(vc: FoldersVC(homeViewModel: homeViewModel),tabType: .savedRecipes)
        let tab4 = createTabNC(vc: SettingsVC(authVM: authVM),tabType: .settings)
        UITabBar.appearance().tintColor = .primary
        viewControllers = [tab1,tab2,tab3,tab4]
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addUnderlineToSelectedTab()
    }
    
    func createTabNC(vc: UIViewController,tabType:TabItem) -> UINavigationController {
        vc.tabBarItem = UITabBarItem(title: nil, image: tabType.image, selectedImage: tabType.selectedImage)
        return UINavigationController(rootViewController: vc)
    }
    
    func selectTab(atIndex index: Int) {
        guard index >= 0 && index < (viewControllers?.count ?? 0) else { return }
        selectedIndex = index
    }
}

//MARK: Tab Bar Appearnace
extension MainTabController {
    
    private func configure() {
        tabBar.frame.size.height = tabBarHeight
        adjustTabBarItemImagesInsets()
        addTopBorder()
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor(hex: "FCFCFC")
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        }
    }
    
    func addTopBorder() {
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor(hex: "E5E5E5")
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: borderHeight)
        tabBar.addSubview(topBorder)
    }
    
    func adjustTabBarItemImagesInsets() {
        if let items = tabBar.items {
            for item in items {
                item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            }
        }
    }
    
    func addUnderlineToSelectedTab() {
        guard let tabBarItems = tabBar.items, !tabBarItems.isEmpty else { return }
        
        let fixedUnderlineWidth: CGFloat = 41.0
        let underlineHeight: CGFloat = 3.0 + borderHeight
        let tabWidth = tabBar.frame.width / CGFloat(tabBarItems.count)
        let underlineXPosition = CGFloat(selectedIndex) * tabWidth + (tabWidth - fixedUnderlineWidth) / 2
        let underlineYPosition = borderHeight
        
        if underlineView == nil {
            createUnderlineView(at: CGRect(x: underlineXPosition, y: underlineYPosition, width: fixedUnderlineWidth, height: underlineHeight))
        }
        
        UIView.animate(withDuration: 0.2) {
            self.underlineView?.frame = CGRect(x: underlineXPosition, y: underlineYPosition, width: fixedUnderlineWidth, height: underlineHeight)
        }
    }

    private func createUnderlineView(at frame: CGRect) {
        underlineView = UIView(frame: frame)
        underlineView?.backgroundColor = UIColor(red: 127/255, green: 82/255, blue: 131/255, alpha: 1) // Color #7F5283
        tabBar.addSubview(underlineView!)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createUnderlinePath().cgPath
        underlineView?.layer.mask = shapeLayer
    }

    private func createUnderlinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 41, y: 0))
        path.addLine(to: CGPoint(x: 41, y: 0))
        path.addCurve(to: CGPoint(x: 38, y: 3.0 + borderHeight), controlPoint1: CGPoint(x: 41, y: (3.0 + borderHeight) * 0.567), controlPoint2: CGPoint(x: 39.7, y: 3.0 + borderHeight))
        path.addLine(to: CGPoint(x: 3, y: 3.0 + borderHeight))
        path.addCurve(to: CGPoint(x: 0, y: 0), controlPoint1: CGPoint(x: 1.3, y: 3.0 + borderHeight), controlPoint2: CGPoint(x: 0, y: (3.0 + borderHeight) * 0.567))
        path.close()
        return path
    }
}

