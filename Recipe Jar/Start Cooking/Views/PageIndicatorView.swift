import SwiftUI
struct PageIndicatorView: View {
    // MARK: - Public Properties
    let numberOfPages: Int
    let currentIndex: Int
    
    // MARK: - Drawing Constants
    
    private let circleSize: CGFloat = 7
    private let circleSpacing: CGFloat = 8
    
    private let primaryColor = Color(uiColor: UIColor(red: 237.0/255, green: 196.0/255, blue: 50.0/255, alpha: 1))
    private let secondaryColor = Color(uiColor: UIColor(red: 217.0/255, green: 217.0/255, blue: 217.0/255, alpha: 1))
    
    private let smallScale: CGFloat = 0.6
    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0..<numberOfPages,id:\.self) { index in // 1
                Circle()
                    .fill(currentIndex == index ? primaryColor : secondaryColor) // 2
                    .scaleEffect(currentIndex == index ? 1 : smallScale)
                    .frame(width: circleSize, height: circleSize)
                    .transition(AnyTransition.opacity.combined(with: .scale))
                    .id(index)
            }
        }
    }

    // MARK: - Private Methods
    func shouldShowIndex(_ index: Int) -> Bool {
        ((currentIndex - 1)...(currentIndex + 1)).contains(index)
    }
}
