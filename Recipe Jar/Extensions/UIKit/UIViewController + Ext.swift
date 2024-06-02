import UIKit
import SwiftUI
extension UIViewController {
    func hostSwiftUIView<Content: View>(topConstant: CGFloat = UIScreen.screenHeight*0.14084507, @ViewBuilder content: () -> Content) {
        let hostingController = UIHostingController(rootView: content())
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: topConstant).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: self)

        bringCustomNavigationBarToFront()
    }

    func bringCustomNavigationBarToFront() {
        for subview in view.subviews {
            if subview is CustomNavigationBar {
                view.bringSubviewToFront(subview)
                break
            }
        }
    }
 
//    func showTabBar() {
//          guard let tabBar = self.tabBarController?.tabBar else { return }
//
//          UIView.animate(withDuration: 0.3, animations: {
//              // Move the tab bar to its original position
//              tabBar.frame.origin.y = self.view.frame.height - tabBar.frame.height
//              tabBar.isHidden = false // Ensure the tab bar is visible during the animation
//          })
//      }
//
//      func hideTabBar() {
//          guard let tabBar = self.tabBarController?.tabBar else { return }
//
//          UIView.animate(withDuration: 0.3, animations: {
//              // Move the tab bar just off the bottom of the screen
//              tabBar.frame.origin.y = self.view.frame.height
//          }) { _ in
//              tabBar.isHidden = true // Hide the tab bar after the animation completes to avoid interaction
//          }
//      }

    func adjustTabBarVisibility(shouldShow: Bool) {
        guard let tabBar = self.tabBarController?.tabBar else { return }
        let tabBarHeight = tabBar.frame.size.height
        let viewHeight = self.view.frame.size.height
        let newY = shouldShow ? viewHeight - tabBarHeight : viewHeight

        // Preemptively adjust view layout if needed, especially for view controllers where the tab bar will be hidden
        if !shouldShow {
            self.additionalSafeAreaInsets.bottom = -tabBarHeight
        }

        UIView.animate(withDuration: 0.3, animations: {
            tabBar.frame.origin.y = newY
            tabBar.isHidden = !shouldShow
        }) { _ in
            if shouldShow {
                self.additionalSafeAreaInsets.bottom = 0
            }
        }
    }
    
    ///
    /// Animate the alpha of the view with `duration`.
    /// - Parameter duration: Defualt value for duration is `0.5`.
    ///
    func animate(alpha: CGFloat, with duration: Double = 0.5) {
      UIView.animate(withDuration: duration) {
          self.view.alpha = alpha
      }
    }

}
