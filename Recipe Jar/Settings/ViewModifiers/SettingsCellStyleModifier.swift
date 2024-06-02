//
//  SettingsCellStyleModifier.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import SwiftUI
struct SettingsCellStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(hex:"#7F5283",opacity: 0.08), lineWidth: 1)
            )
    }
}
