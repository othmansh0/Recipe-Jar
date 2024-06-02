//
//  SettingsSection.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 14/05/2024.
//

import SwiftUI
struct SettingsSection<Content: View>: View {
    let title: String
    var topPadding: CGFloat?
    let content: Content
    init(title: String,topPadding: CGFloat? = 35, @ViewBuilder content: () -> Content) {
        self.title = title
        self.topPadding = topPadding
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(CustomFont.medium.font(size: 14))
                .foregroundStyle(Color(hex: "828282"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom,8)
                .isHidden(title.isEmpty, remove: title.isEmpty)

            VStack(alignment: .leading, spacing: 0) {
                content
            }
            .settingsCellStyle()
        }
        .padding(.top,topPadding)
        .padding(.horizontal,24)
    }
}
