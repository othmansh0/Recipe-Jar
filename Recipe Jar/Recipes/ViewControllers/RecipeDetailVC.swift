//
//  RecipeDetailVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 08/05/2024.
//

import UIKit
class RecipeDetailVC: BaseVC {
    let recipeViewModel = RecipeViewModelImpl()
    var homeViewModel: HomeScreenViewModel!
    
    var recipeToShow: Recipe?
    
    init(homeViewModel: HomeScreenViewModel,recipeToShow: Recipe?) {
        super.init(nibName: nil, bundle: nil)
        self.recipeToShow = recipeToShow
        self.homeViewModel = homeViewModel
        
        
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let recipeToShow = recipeToShow else { return }
        setNavigationBarStyle(to: .backButton, buttonImageName: nil)
        hostSwiftUIView(topConstant: 0) {
            RecipeDetailScreen(vm: self.recipeViewModel,recipe: recipeToShow, showSteps: {scale  in self.showSteps( recipeViewModel: self.recipeViewModel, scale: scale)}, homeViewModel: homeViewModel)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        adjustTabBarVisibility(shouldShow: false)
    }
    
    func showSteps(recipeViewModel: RecipeViewModelImpl,scale: Double) {
        DispatchQueue.main.async {
            self.recipeToShow?.steps = recipeViewModel.getRecipeSteps(recipeID: nil)
            let vc = StepsVC(vm: StartCookingViewModel(recipe: self.recipeToShow!), recipeViewModel: recipeViewModel, scale: scale)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
