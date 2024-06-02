//
//  SideMenuOptionsView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 29/05/2024.
//

import SwiftUI

struct SideMenuOptionsView: View {
    let options: [Nameable]
    var optionsImage: Image
    let horizontalSpacing: CGFloat
    @Binding var showOptions: Bool
    let tappedItem: (Nameable) -> ()
    private let verticalSpacing = 10.0

    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(options, id: \.id) { option in
                HStack(spacing: horizontalSpacing) {
                    optionsImage
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color(hex: "#232946"))
                        .frame(width: 24, height: 24)
                    
                    Text(option.name)
                        .lineLimit(1)
                        .foregroundStyle(Color(hex: "#232946"))
                        .font(CustomFont.medium.font(size: 14))
                }
                .frame(height: 24)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.snappy) {
                        tappedItem(option)
                        showOptions = false
                        
                    }
                }
            }
        }
    }
}

