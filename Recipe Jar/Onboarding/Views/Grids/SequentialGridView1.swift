import SwiftUI
import Combine
struct SequentialGridView1: View {
    @State private var currentStep = 0
    let images: [Image]
    @Binding var showFeaturesView: Bool
    private let timerInterval = 0.35
    private var timerPublisher: Timer.TimerPublisher { Timer.publish(every: timerInterval, on: .main, in: .common) }
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 10) {
            images[0]
                .resizable()
                .aspectRatio(1.9, contentMode: .fit)
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .opacity(currentStep >= 1 ? 1 : 0)
                .animation(.easeIn(duration: 1), value: currentStep)
            
            HStack(spacing: 10) {
                ForEach(1..<images.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 167, height: 180)
                        .foregroundStyle(Color(hex:"F5F5F5"))
                        .overlay(
                            images[index]
                                .resizable()
                                .aspectRatio(0.85310734, contentMode: .fit)
                        )
                        .opacity(currentStep > index ? 1 : 0)
                        .animation(.easeIn(duration: 0.35), value: currentStep)
                }
            }
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
