import SwiftUI
import Combine
struct SequentialGridView3: View {
    @State private var currentStep = 0
    let images: [Image]
    @Binding var showFeaturesView: Bool
    private let timerInterval = 0.5
    private var timerPublisher: Timer.TimerPublisher { Timer.publish(every: timerInterval, on: .main, in: .common) }
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 10) {
            images[0]
                .resizable()
                .aspectRatio(0.92934783, contentMode: .fit)
                .cornerRadius(16)
                .scaleEffect(currentStep >= 1 ? 1 : 0, anchor: .bottomLeading)
                .animation(.easeIn(duration: 0.5), value: currentStep)
                .overlay(
                    images[1]
                        .resizable()
                        .frame(width: 160, height: 160, alignment: .bottomLeading)
                        .offset(y: 7)
                        .scaleEffect(currentStep >= 2 ? 1 : 0, anchor: .bottomLeading)
                        .animation(.easeIn(duration: 0.5), value: currentStep)
                    ,
                    alignment: .bottomLeading
                )
                .padding(.horizontal, 24)
            
        }
        .onAppear {
            startOrResumeTimer()
        }
        .onDisappear {
            stopTimer()
        }
        
    }
    private func startOrResumeTimer() {
        timerCancellable = timerPublisher.autoconnect().sink { _ in
            if currentStep < images.count {
                currentStep += 1
            } else if currentStep >= images.count {
                withAnimation(.easeIn(duration: 0.5)) {
                    showFeaturesView = true
                }
                stopTimer()
            }
        }
    }
    
    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
