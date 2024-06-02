//
//  ConditionalSettingsCellStyle.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import SwiftUI
struct ConditionalSettingsCellStyle: ViewModifier {
    let apply: Bool

    func body(content: Content) -> some View {
        if apply {
            content.modifier(SettingsCellStyleModifier())
        } else {
            content
        }
    }
}

extension View {
    func settingsCellStyle(apply: Bool = true) -> some View {
        modifier(ConditionalSettingsCellStyle(apply: apply))
    }
}
