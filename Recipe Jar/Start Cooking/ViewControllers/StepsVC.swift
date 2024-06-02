//
//  StepsVC.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 08/05/2024.
//

import UIKit
import SwiftUI
import YouTubePlayerKit

class StepsVC: BaseVC {
    var recipeViewModel: RecipeViewModelImpl!
    var vm: StartCookingViewModel!
    var scale: Double!
    
    init(vm: StartCookingViewModel ,recipeViewModel: RecipeViewModelImpl, scale: Double) {
        super.init(nibName: nil, bundle: nil)
        self.vm = vm
        self.recipeViewModel = recipeViewModel
        self.scale = scale
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeIsLoading()
        setNavigationBarStyle(to: .stepsItems, buttonImageName: nil,isYouTubeDisabled: vm.isYoutubeDisabled)
        if let selectedRecipe = recipeViewModel.selectedRecipe {
            hostSwiftUIView {
                StepsScreen(isPresentingStepsScreen: .constant(false), vm: vm, recipeViewModel: recipeViewModel, openYouTubeScreen: {[weak self] videoObj in self?.showYoutubeScreen(videoObject: videoObj)} )
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recipeViewModel.selectedRecipe?.videoUrl == nil || recipeViewModel.selectedRecipe?.title == nil || recipeViewModel.selectedRecipe?.videoImageUrl == nil {
            vm.isYoutubeDisabled = true
        }
    }

    private func observeIsLoading() {
        vm.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                self?.customNavBar.adjustStepsItemsEnablity(enability: !isLoading)
            }
            .store(in: &cancellables)
    }
}

//MARK: ToolBar items
extension StepsVC {
    override func firstItemAction() {
        let vc = PopoverContentController(rootView: IngredientsPopOverListView(ingredients: recipeViewModel.selectedRecipeIngredients, scale: scale))
        presentPopover(vc: vc, sourceView: customNavBar.firstActionItem)
    }
    
    override func secondItemAction() {
        if vm.isYoutubeDisabled {
            let vc = PopoverContentController(rootView: YouTubePopOverView().background(Color(uiColor: UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1))))
            presentPopover(vc: vc, sourceView: customNavBar.secondActionItem)
        }
        else {
            vm.showYoutubeModalView.toggle()
        }
    }
    
    override func thirdItemAction() {
        vm.isReading.toggle()
        vm.checkReading()
    }
    
    override func fourthItemAction() {
        vm.isSpeaking.toggle()
        vm.checkSpeaking()
    }
}
//MARK: Navigators
extension StepsVC {
    func showYoutubeScreen(videoObject: VideoURL) {
        let vc = YouTubeVC(youTubePlayer: YouTubePlayer(stringLiteral: videoObject.youtubeLink ?? ""),videoObject: videoObject,steps: vm.selectedRecipe.steps ?? [])
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: Popover Presentation Delegate
extension StepsVC: UIPopoverPresentationControllerDelegate {
    
    func presentPopover(vc: UIViewController,sourceView: UIView) {
         let popoverContentController = vc // Your custom popover content view controller
         popoverContentController.modalPresentationStyle = .popover
         if let popoverPresentationController = popoverContentController.popoverPresentationController {
             popoverPresentationController.permittedArrowDirections = .up
             popoverPresentationController.sourceView = sourceView
             popoverContentController.view.backgroundColor = UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1)
             popoverPresentationController.backgroundColor = UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 1)
             popoverPresentationController.delegate = self
             present(popoverContentController, animated: true, completion: nil)
         }
     }

    // UIPopoverPresentationControllerDelegate methods
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return .none }
    // Handle the popover dismissal if needed
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {}
    // Return false if you don't want the popover to be dismissible
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool { return true}
}



