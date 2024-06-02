//
//  TransparentBlurView.swift
//  TransparentBlur
//
//  Created by Othman Shahrouri.
//

import SwiftUI

fileprivate struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    func makeUIView(context: Context) -> TransparentBlurViewHelper {
        let view = TransparentBlurViewHelper(removeAllFilters: removeAllFilters)
        return view
    }
    
    func updateUIView(_ uiView: TransparentBlurViewHelper, context: Context) {}
}

/// Disabling Trait Changes for Our Transparent Blur View
class TransparentBlurViewHelper: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        /// Removing Background View, if it's Available
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }
        
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                /// Removing All Expect Blur Filter
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Disabling Trait Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
}


// SwiftUI wrapper with encapsulated modifiers
struct GlassLabelView: View {
    var color: Color
    var removeAllFilters: Bool
    var opactiy: CGFloat
    var blurRadius: CGFloat
    var isBlurOpaque: Bool
    var radius: CGFloat
    var body: some View {
        TransparentBlurView(removeAllFilters: removeAllFilters)
            .blur(radius: blurRadius , opaque: isBlurOpaque)
            .background(color.opacity(opactiy))
    }
}


fileprivate struct GlassBackgroundModifier: ViewModifier {
    var color: Color
    var removeAllFilters: Bool
    var opactiy: CGFloat
    var blurRadius: CGFloat
    var isBlurOpaque: Bool
    var radius: CGFloat
    func body(content: Content) -> some View {
        content
            .background(
                GlassLabelView(color: color, removeAllFilters: removeAllFilters, opactiy: opactiy, blurRadius: blurRadius  ,isBlurOpaque: isBlurOpaque, radius: radius)
            )
            .cornerRadius(radius)
    }
}

extension View {
    func glassBackground(color: Color = .white, removeAllFilters: Bool, opactiy: CGFloat, blurRadius: CGFloat = 0, isBlurOpaque: Bool = false, radius: CGFloat = 0) -> some View {
        self.modifier(GlassBackgroundModifier(color: color,removeAllFilters: removeAllFilters, opactiy: opactiy, blurRadius: blurRadius, isBlurOpaque: isBlurOpaque, radius: radius))
    }
}
