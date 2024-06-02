//
//  popUpWithBlurView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 07/03/2024.
//

import SwiftUI
struct popUpWithBlurView<Data>: View where Data: Nameable {
    let title: String?
    let detail: String?
    @Binding var isActive: Bool
    @Binding var shouldBlur: Bool
    @Binding var selectedItem: Data
    let items: [Data]
    let tapAction: () async -> Void
    let tapOutsideAction: () -> Void
    
    
    var body: some View {
        ZStack {
            ConditionalBlurView(isActive: isActive, style: .dark, animationDuration: 0.3, finalAlpha: 0.2)
                .id("ConditionalBlurView1")
                .transition(.opacity)
                .ignoresSafeArea()
                .allowsHitTesting(isActive)
                .onTapGesture {
                    isActive = false
                    shouldBlur = false
                }
            
            
            PopUpMenuView(menuTitle: title ?? "",
                          menuMsg: detail ?? "",
                          items: items,
                          isPresented: isActive) { tappedIndex in
                selectedItem = items[tappedIndex]
                Task {  await tapAction() }
            }
        }
    }
}
