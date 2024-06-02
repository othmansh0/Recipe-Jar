import SwiftUI
import Foundation
import SwiftUI
import Foundation

public struct SwiftUIShimmer: ViewModifier {
    @Binding var active: Bool
    private var duration: Double
    private var bounce: Bool
    
    public init(active: Binding<Bool>, duration: Double = 1.5, bounce: Bool = false) {
        self._active = active
        self.duration = duration
        self.bounce = bounce
    }
    
    @State private var phase: CGFloat = 0.0
    
    public func body(content: Content) -> some View {
        // Conditional modifier application based on `active` state
        if active {
            content
                .modifier(AnimatedMask(phase: phase))
                .animation(Animation.linear(duration: duration).repeatForever(autoreverses: bounce), value: phase)
                .onAppear {
                    phase = 0.8 // Initial phase offset for shimmer effect
                }
        } else {
            content
        }
    }
    
    struct AnimatedMask: AnimatableModifier {
        var phase: CGFloat
        
        var animatableData: CGFloat {
            get { phase }
            set { phase = newValue }
        }
        
        func body(content: Content) -> some View {
            content.mask(GradientMask(phase: phase).scaleEffect(3))
        }
    }
    
    struct GradientMask: View {
        let phase: CGFloat
        var body: some View {
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.black.opacity(0.3), location: phase),
                .init(color: Color.black, location: phase + 0.1),
                .init(color: Color.black.opacity(0.3), location: phase + 0.2)
            ]), startPoint: .leading, endPoint: .trailing)
        }
    }
}

public extension View {
    func shimmering(active: Bool = true, duration: Double = 1.5, bounce: Bool = false) -> some View {
        modifier(SwiftUIShimmer(active: .constant(active), duration: duration, bounce: bounce))
    }
}
