//
//  SideMenuViewController.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 25/03/2024.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var folders: [Folder]!
    var categories: [ShoppingListCategory]!
    var shoppingListVM: ShoppingListViewModel!
    var homeViewModel: HomeScreenViewModel!
    
    let menuWidth: CGFloat = UIScreen.screenWidth * (1-0.22307692)
    
    init(folders: [Folder],categories: [ShoppingListCategory],shoppingListVM: ShoppingListViewModel,homeViewModel: HomeScreenViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.folders = folders
        self.categories = categories
        self.shoppingListVM = shoppingListVM
        self.homeViewModel = homeViewModel
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hostSwiftUIView(topConstant: 0) {
            SideMenuView(folders: folders,
                         categories: categories,
                         openFolder: { [weak self] tappedFolder in
                guard let self = self else { return}
                showRecipesVC(for: tappedFolder)},
                         openShoppingList: { [weak self] tappedList in
                guard let self = self else { return}
                showShoppingListVC(viewModel: shoppingListVM, selectedCategory: tappedList)},
                         openHelpScreen: showHelpVC
            )
        }
    }
    
    private func setupMenuView() {
        view.backgroundColor = .gray
        view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: UIScreen.main.bounds.height)
    }
    
    func showMenu(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = 0
        }, completion: { _ in
            completion?()
        })
    }
    
    // Hide the side menu with animation
    func hideMenu(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.origin.x = -self.menuWidth
        }, completion: { _ in
            completion?()
        })
    }
}


//MARK: Navigators
extension SideMenuViewController {
    func showRecipesVC(for folder: Folder) {
        let vc = RecipesVC(homeViewModel: homeViewModel, folderID: folder.id, folderName: folder.name,shouldHideTabBarOnDisappear: true)
        vc.customNavBar.titleLabel.text = folder.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showShoppingListVC(viewModel: ShoppingListViewModel, selectedCategory: ShoppingListCategory) {
        let vc = ShoppingListItemsVC(viewModel: viewModel, selectedCategory: selectedCategory)
        vc.customNavBar.titleLabel.text = selectedCategory.name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showHelpVC() {
        let vc = FAQVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
