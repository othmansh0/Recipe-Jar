//
//  BackButtonStyle.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 26/01/2024.
//

import UIKit
enum BackButtonStyle {
    case arrow
    case cross
    
    var buttonImage: UIImage {
        switch self {
        case .arrow:
           //UIImage(systemName: "chevron.left", withConfiguration: config)!
            return UIImage(systemName: "chevron.left")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 22, weight: .bold))
        case .cross:
            return UIImage(systemName: "multiply")!.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium))
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .arrow:
           //UIImage(systemName: "chevron.left", withConfiguration: config)!
            return CGSize(width: 16, height: 32)
        case .cross:
            return CGSize(width: 22, height: 26)
        }
    }
}
