import Foundation
import SwiftUI
import UIKit
class SharedDefaults {
    static let shared = SharedDefaults()
    let defaults = UserDefaults(suiteName: "group.userIDGroup")!
    private init(){}
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}


