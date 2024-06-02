import SwiftUI
import UIKit
enum CustomFont {
    case light
    case regular
    case bold
    case medium
    
    private var firaSansName: String {
        switch self {
        case .light:
            return "FiraSans-Light.ttf"
        case .regular:
            return "FiraSans-Regular"
        case .bold:
            return "FiraSans-Bold"
        case .medium:
            return "FiraSans-Medium"
        }
    }
    
    private var poppinsName: String {
        switch self {
        case .light:
            return "Poppins-Light.ttf"
        case .regular:
            return "Poppins-Regular"
        case .bold:
            return "Poppins-Bold"
        case .medium:
            return "Poppins-Medium"
        }
    }
    
    func font(_ fontFamily: FontFamily = .firaSans,size: CGFloat) -> Font {
        return Font.custom(fontFamily == .firaSans ? firaSansName : poppinsName, size: size)
    }
    
    enum FontFamily {
        case firaSans
        case poppins
    }
}




    



