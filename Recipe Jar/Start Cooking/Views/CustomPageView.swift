import SwiftUI
struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    var isEnglish:Bool
    // Properties....
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    let autoPlayDuration: Int?
    let stopAutoPlayAfterOneCyle: Bool
    // Timer properties
    var timer: Timer?
    @State var autoplayWorkItem: DispatchWorkItem?
    
    @State private var isUserSwiping = false
    @State private var userSwipedToNewIndex = false
    
    // Offset...
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    let sensitivityFactor: CGFloat = 2.75
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T],isEnglish:Bool,autoPlayDuration: Int?,stopAutoPlayAfterOneCyle: Bool, @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.isEnglish = isEnglish
        self.autoPlayDuration = autoPlayDuration
        self.stopAutoPlayAfterOneCyle = stopAutoPlayAfterOneCyle
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View {
        GeometryReader{ proxy in
            // One Sided Snap Carousel
            let width = proxy.size.width - ( trailingSpace - spacing )
            let adjustMentWidth = (trailingSpace / 2) - spacing
            HStack (spacing: spacing) {
                ForEach(list,id:\.id) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            // Spacing will be horizontal padding...
            .padding(.horizontal, spacing)
            // Setting only after 0th index...
            .offset(x: (CGFloat(currentIndex) * -width) + (adjustMentWidth) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = isEnglish ? value.translation.width : -value.translation.width
                    })
                    .onEnded({ value in
                        
                        // Updating Current Index....
                        let offsetX = value.translation.width
                        
                        // Were going to convert the tranlsation into progreess ( 0 - 1 )
                        // and round the value...
                        // based on the progress increasing or decreasing the currentInde....
                        
                        let progress = (isEnglish ? -offsetX / width : offsetX / width)*sensitivityFactor
                        var roundIndex = progress.rounded()
                        
                        //Limit the change in index to 1 per gesture
                        if roundIndex > 1 {//avoid skipping pages when user scroll from edge to edge
                            roundIndex = 1
                        } else if roundIndex < -1 {
                            roundIndex = -1
                        }
                        // setting max....
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        // updating index....
                        currentIndex = index
                        isUserSwiping = false
                        resetTimer()
                    })
                    .onChanged({ value in
                        // updating only index...
                        let verticalTranslation = value.translation.height
                        // Updating Current Index....
                        let offsetX = value.translation.width
                        // Were going to convert the tranlsation into progreess ( 0 - 1 )
                        // and round the value...
                        // based on the progress increasing or decreasing the currentInde....
                        let progress = (isEnglish ? -offsetX / width : offsetX / width)*sensitivityFactor
                        var roundIndex = progress.rounded()
                        // Limit the change in index to 1 per gesture
                        if roundIndex > 1 {
                            roundIndex = 1
                        } else if roundIndex < -1 {
                            roundIndex = -1
                        }
                        // setting max....
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        //                        isUserSwiping = true
                        if abs(offsetX) > abs(verticalTranslation) {
                            // Horizontal swipe
                            isUserSwiping = true
                        } else {
                            // Vertical swipe
                            isUserSwiping = false
                        }
                        
                        if Int(roundIndex) != 0 {
                            userSwipedToNewIndex = true
                        }
                        
                    })
            )
            .onAppear {
                startAutoplay()
            }
            .onDisappear {
                stopAutoplay()
            }
            
            .onChange(of: index) { newIndex in
                guard newIndex != currentIndex && isUserSwiping == false else {
                    // Index is not changed, do nothing
                    return
                }
                withAnimation {
                    currentIndex = newIndex
                }
            }
            
        }
        // Animatiing when offset = 0
        .animation(.easeInOut, value: offset == 0)
        
    }
    private func startAutoplay() {
        guard let autoPlayDuration = autoPlayDuration else { return }
        guard !isUserSwiping || !userSwipedToNewIndex else {
            // Don't start autoplay if the user is manually swiping
            return
        }
        autoplayWorkItem = DispatchWorkItem {
            let pageCount = list.count
            DispatchQueue.main.async {
                withAnimation {
                    currentIndex = (currentIndex + 1) % pageCount
                    index = currentIndex // Update the binding index
                    if self.currentIndex != pageCount - 1 || !stopAutoPlayAfterOneCyle  {
                        self.startAutoplay()
                    }
                }
            }
        }
        let delayTime: DispatchTimeInterval = .seconds(autoPlayDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: autoplayWorkItem!)
    }

    private func stopAutoplay() {
        autoplayWorkItem?.cancel()
        autoplayWorkItem = nil
    }
    private func resetTimer() {
        autoplayWorkItem?.cancel()
        startAutoplay()
    }
}
