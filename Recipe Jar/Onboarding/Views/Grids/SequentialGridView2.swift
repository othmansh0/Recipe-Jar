import SwiftUI
import Combine
struct SequentialGridView2: View {
    @State private var currentStep = 0
    let images: [Image]
    @Binding var showFeaturesView: Bool
    private let timerInterval = 0.35
    private var timerPublisher: Timer.TimerPublisher { Timer.publish(every: timerInterval, on: .main, in: .common) }
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                images[0]
                    .resizable()
                    .frame(width: 203, height: 238, alignment: .leading)
                    .opacity(currentStep >= 1 ? 1 : 0)
                    .animation(.easeIn(duration: 0.35), value: currentStep)
                
                images[1]
                    .resizable()
                    .frame(width: 131, height: 238, alignment: .leading)
                    .opacity(currentStep >= 2 ? 1 : 0)
                    .animation(.easeIn(duration: 0.35), value: currentStep)
            }
            .frame(height: 238)
            
            HStack {
                Circle()
                    .fill(.white)
                    .frame(width: 65.41, height: 65.41)
                    .overlay(
                        images[2]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 32.05, height: 22.44)
                            .opacity(currentStep >= 4 ? 1 : 0)
                            .animation(.easeIn(duration: 0.35), value: currentStep)
                    )
                
                Spacer()
                
                Circle()
                    .fill(.white)
                    .frame(width: 65.41, height: 65.41)
                    .overlay(
                        images[3]
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30.62, height: 34.79)
                            .opacity(currentStep >= 5 ? 1 : 0)
                            .animation(.easeIn(duration: 0.35), value: currentStep)
                    )
                
                Spacer()
                
                Circle()
                    .fill(.white)
                    .frame(width: 65.41, height: 65.41)
                    .overlay(
                        images[4]
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 34.61, height: 34.61)
                            .opacity(currentStep >= 6 ? 1 : 0)
                            .animation(.easeIn(duration: 0.35), value: currentStep)
                    )
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 28)
            .background(
                Color(red: 245.0/255, green: 245.0/255, blue: 245.0/255),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .padding(.horizontal, 24)
            .opacity(currentStep >= 3 ? 1 : 0)
            .animation(.easeIn(duration: 0.35), value: currentStep)
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
            if currentStep <= images.count {
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
