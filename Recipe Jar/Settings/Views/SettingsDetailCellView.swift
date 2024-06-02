//
//  SettingsDetailCellView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 14/05/2024.
//

import SwiftUI
struct SettingsDetailCellView: View {
    
    let title: String
    var textColor: Color?
    var image: Image?
    var imageColor: Color?
    var addBorder: Bool = false
    var isArrowHidden: Bool = false
    let action: () -> ()
    
    private let color = Color(hex: "#232946")
    var body: some View {
        HStack(spacing: 10) {
            if let image = image {
                image
                    .resizable()
                    .renderingMode(imageColor != nil ? .template : .original)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(imageColor ?? color )
            }
            Text(title)
                .font(CustomFont.regular.font(size: 15))
                .foregroundStyle(textColor ?? color)
            Spacer()
            
            Image(systemName: "chevron.forward")
                .resizable()
                .renderingMode(.template)
                .font(CustomFont.medium.font(size: 14))
                .foregroundStyle(Color(hex: "CECECE"))
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .isHidden(isArrowHidden, remove: isArrowHidden)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .settingsCellStyle(apply: addBorder)
        .onTapGesture {
            action()
        }
    }
}
