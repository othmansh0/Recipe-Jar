//
//  ConditionalBlurView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI
struct ConditionalBlurView: UIViewRepresentable {
    var isActive: Bool = false
    var style: UIBlurEffect.Style = .dark
    var animationDuration: Double = 0.3
    var finalAlpha: CGFloat = 0.2
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.alpha = 0
        return blurEffectView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        if isActive {
            UIView.animate(withDuration: animationDuration) {
                uiView.alpha = self.finalAlpha
                uiView.isUserInteractionEnabled = true
            }
        } else {
            UIView.animate(withDuration: animationDuration, animations: {
                uiView.alpha = 0
            }) { _ in
                uiView.isUserInteractionEnabled = false
            }
        }
    }
}
