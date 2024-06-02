import UIKit
import YouTubePlayerKit
import VisionKit
class YouTubeVC: BaseVC {
    var youTubePlayer: YouTubePlayer!
    var videoObject: VideoURL!
    var steps: [Step]!
    
    init(youTubePlayer: YouTubePlayer ,videoObject: VideoURL,steps: [Step]) {
        super.init(nibName: nil, bundle: nil)
        self.youTubePlayer = youTubePlayer
        self.videoObject = videoObject
        self.steps = steps
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarStyle(to: .stepsItems, buttonImageName: nil)
        
        hostSwiftUIView(topConstant: 0) {
            YouTubeScreen(youTubePlayer: YouTubePlayer(stringLiteral: videoObject.youtubeLink ?? ""),videoObj: videoObject,steps: steps, exitYouTubeScreen: { [weak self] in self?.navigationController?.popViewController(animated: true) }, stopCooking: stopCooking)
        }
    }
    
    
    func stopCooking() {
        guard let navigationController = self.navigationController else { return }
        self.adjustTabBarVisibility(shouldShow: false)
        if let vc1 = navigationController.viewControllers.first(where: { $0 is RecipeDetailVC }) as? RecipeDetailVC {
            vc1.adjustTabBarVisibility(shouldShow: false)
            navigationController.popToViewController(vc1, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hideNavigationBar()
    }
}
