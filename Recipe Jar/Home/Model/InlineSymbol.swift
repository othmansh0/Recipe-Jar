import SwiftUI
struct InlineSymbol {
    let name: String
    let accessibilityLabel: String
    let color: Color?
    let position: Int
    
    init(name: String, accessibilityLabel: String, color: Color? = nil, position: Int) {
        self.name = name
        self.accessibilityLabel = accessibilityLabel
        self.color = color
        self.position = position
    }
}
