//
//  SettingsToggleCellView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 14/05/2024.
//

import SwiftUI
struct SettingsToggleCellView: View {
    let title: String
    let image: Image
    var imageColor: Color?
    var addBorder: Bool = false
    @Binding var isOn: Bool
    let action: () -> ()
    
    private let color = Color(hex: "#232946")
   
    var body: some View {
        Toggle(isOn: Binding(get: { self.isOn }, set: { _ in action() })) {
            HStack(spacing: 10) {
               image
                    .resizable()
                    .renderingMode(imageColor != nil ? .template : .original)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(imageColor ?? color )
                  
                Text(title)
                    .font(CustomFont.regular.font(size: 15))
                    .foregroundStyle(color)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color(hex:"7F5283")))
        .overlay(
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 51, height: 31,alignment: .trailing)
                .contentShape(Rectangle())
                .onTapGesture {
                    action()
                },alignment: .trailing)
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .settingsCellStyle(apply: addBorder)
  
    }
}
