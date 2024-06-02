//
//  RecipesVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 08/05/2024.
//

import UIKit
class RecipesVC: BaseVC {
    let vm = RecipeViewModelImpl()
    var homeViewModel: HomeScreenViewModel!
    var folderID: Int!
    var folderName: String!
    var shouldHideTabBarOnDisappear: Bool = false
    var swiftUIScreen: RecipesScreen!
    
    init(homeViewModel: HomeScreenViewModel,folderID: Int,folderName: String,shouldHideTabBarOnDisappear: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = homeViewModel
        self.folderID = folderID
        self.folderName = folderName
        self.shouldHideTabBarOnDisappear = shouldHideTabBarOnDisappear
        self.swiftUIScreen = RecipesScreen(vm: vm, categoryID: folderID, showRecipeDetail: { [weak self] recipe in
            guard let self = self else { return }
            self.showRecipeDetail(selectedRecipe: recipe)
        })
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .chevronButton, buttonImageName: nil)
        hostSwiftUIView {
            swiftUIScreen
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        adjustTabBarVisibility(shouldShow: !shouldHideTabBarOnDisappear)
    }
      
    override func rightButtonAction() {}
    
    func showRecipeDetail(selectedRecipe: Recipe) {
        let vc = RecipeDetailVC(homeViewModel: homeViewModel, recipeToShow: selectedRecipe)
        navigationController?.pushViewController(vc, animated: true)
    }
}
