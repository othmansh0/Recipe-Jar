//
//  ShoppingCategoriesVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 19/05/2024.
//

import UIKit
class ShoppingCategoriesVC: BaseVC {
    var viewModel: ShoppingListViewModel!

    init(shoppingListVM: ShoppingListViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = shoppingListVM
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarColor(color: .white)
        let actions = [UIAction(title: "Delete Lists") { _ in self.viewModel.deleteListsPressed() }, UIAction(title: "Rename Lists") { _ in self.viewModel.renameListPressed() }]
        setNavigationBarStyle(to: .titleWithOneButton, buttonImageName: "add_shopping_category", menuActions: actions)
        setNavigationBarTitle(titleIfRootVC: "Shopping List")
        hostSwiftUIView { ShoppingCategoriesScreen(viewModel: viewModel, showShoppingListScreen: showShoppingListScreen) }
        subscribeToViewModelBlurEffect(shouldBlurPublisher: viewModel.$shouldBlur.eraseToAnyPublisher())
    }

    func showShoppingListScreen(selectedCategory: ShoppingListCategory) {
        // Check if the view controller already exists in the navigation stack
        if let existingVC = navigationController?.viewControllers.first(where: {
            ($0 as? ShoppingListItemsVC)?.selectedCategory.id == selectedCategory.id
        }) as? ShoppingListItemsVC {
            viewModel.selectedCategory = selectedCategory
            existingVC.customNavBar.titleLabel.text = selectedCategory.name
            navigationController?.popToViewController(existingVC, animated: true)
        } else {
            // Create and push the new view controller if it doesn't exist
            let vc = ShoppingListItemsVC(viewModel: viewModel, selectedCategory: selectedCategory)
            viewModel.selectedCategory = selectedCategory
            vc.customNavBar.titleLabel.text = selectedCategory.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
