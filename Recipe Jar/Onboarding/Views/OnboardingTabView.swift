//
//  OnboardingTabView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 08/05/2024.
//

import SwiftUI
struct OnboardingTabView: View {
    
    let tab: OnboardingModel
    var namespace: Namespace.ID
    @State var showFeatures: Bool
    @Binding var index: Int
    @Binding var showButton: Bool
    
    var body: some View {
        ZStack(alignment:.topLeading) {
            VStack(alignment: .leading,spacing: 0) {
                OnboardingGridView(tabType: tab, namespace: namespace,showFeaturesView: $showFeatures)
                    .padding(.top,22)
                
                if showFeatures {
                    FeaturesView(title: tab.title, features: tab.subtitles)
                        .padding(.horizontal,24)
                        .padding(.top,32)
                        .transition(.move(edge: .bottom))
                        .animation(.easeIn(duration: 0.5), value: showFeatures)
                }
            }
            .frame(maxHeight: .infinity,alignment:.topLeading)
        }
        .onChange(of: showFeatures) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        showButton = true
                    }
                }
            } else {
                showButton = false
            }
        }
    }
}
