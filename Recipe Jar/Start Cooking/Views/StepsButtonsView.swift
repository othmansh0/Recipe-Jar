//
//  StepsButtonsView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 17/05/2024.
//

import SwiftUI
struct StepsButtonsView: View {
    let backAction: () -> Void
    let nextAction: () -> Void
    let checkReading: () -> Void
    var body: some View {
        HStack(spacing: -8){
            Button {
                backAction()
                checkReading()
            } label: { Image("backButton") }
            
            Button {
                checkReading()
            } label: {
                Image("RepeatButton")
            }
            Button {
                nextAction()
                checkReading()
            } label: {
                Image("nextButton")
            }
        }
        .padding(.bottom,UIScreen.screenHeight * 0.08)
    }
}
