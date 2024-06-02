//
//  LottieRefreshView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 1/05/2024.
//

import SwiftUI
import Lottie

public struct LottieRefreshView: View {
    @Binding var state: RefresherState
    var loopMode: LottieLoopMode = .loop
    @State var playbackMode: LottiePlaybackMode = LottiePlaybackMode.paused

    var foreverAnimation: SwiftUI.Animation  {
        Animation.linear(duration: 1.0)
            .repeatForever(autoreverses: false)
    }
    
    public var body: some View {
        VStack {
            switch state.mode {
            case .notRefreshing:
                LottieView(animation: .named("loading_purple"))
                    .playing(loopMode: .loop)
                    .animationSpeed(0.70)
                    .playbackMode(.paused)
                    .frame(width: 50, height: 50)
            case .pulling:
                LottieView(animation: .named("loading_purple"))
                    .playing(loopMode: .loop)
                    .animationSpeed(0.70)
                    .frame(width: 50, height: 50)
              case .refreshing:
                LottieView(animation: .named("loading_purple"))
                    .playing(loopMode: .loop)
                    .animationSpeed(0.70)
                    .frame(width: 50, height: 50)
            }
        }
    }
}
