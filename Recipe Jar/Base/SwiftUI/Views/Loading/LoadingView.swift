import SwiftUI
import Lottie
struct LoadingView: View {
    var loadingType: LoadingType = .purpleLottie
    let loadingMessage: String
    var backgroundColor: Color?
    var body: some View {
        ZStack(alignment: .center) {
            if loadingType == .defualtProgressView {
                VStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(.circular)
                    Text (loadingMessage)
                }
                .background(backgroundColor ?? .clear)
            }
            else {
                    VStack(spacing: 0) {
                        LottieView(animation: .named(loadingType.rawValue))
                            .playing(loopMode: .loop)
                            .animationSpeed(0.70)
                        Text (loadingMessage)
                            .font(CustomFont.medium.font(size: 15))
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(.top,10)
                            .isHidden(loadingMessage.isEmpty, remove: loadingMessage.isEmpty)
                        
                    }
                    .frame(maxHeight:.infinity,alignment: .center)
                    .padding(.bottom,83)
            }
        }
    }
}

