import UIKit

class FoldersVC: BaseVC {
    let vm = FolderViewModel()
    var homeViewModel: HomeScreenViewModel!
    
    init(homeViewModel: HomeScreenViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel = homeViewModel
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustTabBarVisibility(shouldShow: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .titleWithOneButton, buttonImageName: "plus_new_item")
        setNavigationBarTitle(titleIfRootVC: "Saved")
        hostSwiftUIView {
            FoldersScreen(vm: vm, showRecipes: showRecipesScreen)
        }
    }
    
    override func rightButtonAction() {
        vm.showCreateFolder = true
    }
    
    
    func showRecipesScreen(folderID: Int,folderName: String) {
        let vc = RecipesVC(homeViewModel: homeViewModel, folderID: folderID, folderName: folderName)
        vc.customNavBar.titleLabel.text = folderName
        navigationController?.pushViewController(vc, animated: true)
    }
}
