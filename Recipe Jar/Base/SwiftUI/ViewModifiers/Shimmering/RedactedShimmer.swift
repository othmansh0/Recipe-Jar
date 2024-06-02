import SwiftUI
import Foundation
public struct RedactAndShimmerViewModifier: ViewModifier {
    private let condition: Bool

    public init(condition: Bool) {
        self.condition = condition
    }
    
    public func body(content: Content) -> some View {
        content
            .redacted(reason: condition ? .placeholder : [])
            .shimmering(active: condition)
    }
}

extension View {
    public func redactShimmer(condition: Bool) -> some View {
        modifier(RedactAndShimmerViewModifier(condition: condition))
    }
}
