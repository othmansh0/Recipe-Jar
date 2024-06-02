import SwiftUI
struct TextWithSFSymbolView: View {
    let text: String
    let symbols: [InlineSymbol]
    var body: some View {
        createTextWithSymbols()
    }
    
    private func createTextWithSymbols() -> Text {
        let words = text.split(separator: " ").map { String($0) }
        var output = Text("")
        var currentIndex = 0
        
        let sortedSymbols = symbols.sorted(by: { $0.position < $1.position })
        for symbol in sortedSymbols {
            while currentIndex < symbol.position && currentIndex < words.count {
                output = output + Text(words[currentIndex] + " ")
                currentIndex += 1
            }
            
            let symbolText = Text(Image(systemName: symbol.name))
                .foregroundColor(symbol.color)
                .accessibilityLabel(Text(symbol.accessibilityLabel))
            output = output + symbolText + Text(" ")
        }
        
        while currentIndex < words.count {
            output = output + Text(words[currentIndex] + " ")
            currentIndex += 1
        }
        return output
    }
}
