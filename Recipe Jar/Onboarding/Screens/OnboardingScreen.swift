//
//  ContentView.swift
//  Recipe Jar Onboarding
//
//  Created by Othman Shahrouri on 21/03/2024.
//

import SwiftUI
struct OnboardingScreen: View {
    @ObservedObject var vm: AuthViewModel
    @State private var index = 0
    
    let color = Color(red: 0.498, green: 0.322, blue: 0.514)
    let greyColor = Color(red: 245.0/255, green: 245.0/255, blue: 245.0/255)
    @Namespace var namespace
    
    let tabs = Array(OnboardingModel.allCases)
    @State private var showFeatures = Array(repeating: false, count: 3)
    @State private var showButton = false
    var body: some View {
        let isFinalTab = index == 2
        BaseScreen(isLoading: [$vm.isLoading],loadingMessage: "Loading", isTabBarHidden: true,shouldIgnoreSafeArea: false, error: $vm.error) {
            VStack(spacing: 0) {
                HStack {
                    IndicatorsView(
                        currentTabIndex: index,
                        totalIndices: 3,
                        selectedIndicatorSize: CGSize(width: 60, height: 6),
                        unSelectedIndicatorSize: CGSize(width: 24, height: 6),
                        indicatorColor: color,
                        namespace: namespace)
                    Spacer()
                    Button {
                        Task { await vm.checkForUser() }
                    } label: {
                        Text("SKIP")
                            .foregroundStyle(color)
                            .font(CustomFont.medium.font(size: 16))
                    }
                }
                .padding(.top, 18)
                .padding(.horizontal,24)
                Spacer()
                PageView(pages: tabs.indices.map { index in
                    OnboardingTabView(tab: tabs[index], namespace: namespace, showFeatures: showFeatures[index], index: $index, showButton: $showButton)
                }, currentPage: $index)
                
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .black
                    UIPageControl.appearance().pageIndicatorTintColor = .gray.withAlphaComponent(0.5)
                }
                ButtonViewV2(buttonTitle: isFinalTab ? "Get Started" : "Next", cornerRadius: 10, buttonColor: isFinalTab ? color : greyColor, titleColor: isFinalTab ? .white : .black, titleAlignment: .center, titleFont: CustomFont.medium.font(size: 20), function: index != 2 ? {
                    
                    index = index + 1
                    
                } : {
                    Task { await vm.checkForUser() }
                })
                .opacity(showButton ? 1 : 0)
                .frame(height: 53)
                .padding(.horizontal,24)
                .padding(.bottom,10)
                .transition(.opacity)
                .animation(index == 0 ? .easeIn(duration: 0.5) : nil, value: showButton)
            }
        }
        
    }
}
