//
//  YouTubePopOverView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 18/05/2024.
//

import SwiftUI
struct YouTubePopOverView:View {
    var body: some View {
        Rectangle()
            .fill(Color(hex: "6A6A6A"))
            .frame(width: 208,height: 46)
            .overlay(
                Text("Sorry.. YouTube tutorial for this\nrecipe is unavailable")
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(nil)
                    .padding(.horizontal,11)
                    .foregroundStyle(.white)
                    .font(CustomFont.regular.font(size: 13))
                    .frame(height: 32, alignment: .topLeading)
            )
    }
}
