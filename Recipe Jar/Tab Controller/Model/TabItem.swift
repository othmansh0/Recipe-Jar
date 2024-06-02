//
//  TabItem.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 30/12/2023.
//
import UIKit
enum TabItem {
    case home
    case shoppingList
    case savedRecipes
    case settings
    
    var image: UIImage {
        switch self {
        case .home:
            return UIImage(named: "Home")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .shoppingList:
            return UIImage(named: "Cart")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .savedRecipes:
            return UIImage(named: "bookmark")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .settings:
            return UIImage(named: "Gear")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return UIImage(named: "HomeFill")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .shoppingList:
            return UIImage(named: "CartFill")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .savedRecipes:
            return UIImage(named: "bookmarkFill")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        case .settings:
            return UIImage(named: "GearFill")?.scalePreservingAspectRatio(targetSize: CGSize(width: 28, height: 28)) ?? UIImage()
        }
    }
    
}
