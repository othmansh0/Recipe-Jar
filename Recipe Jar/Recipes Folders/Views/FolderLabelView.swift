//
//  FolderLabelView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 2/05/2024.
//

import SwiftUI

struct FolderLabelView: View {
    let title: String
    let navigateAction: @MainActor () -> Void
    let firstAction: () -> ()
    let secondAction: () -> ()
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
            Spacer()
        }
        .font(CustomFont.medium.font(size: 13))
        .foregroundStyle(.white)
        .padding(.leading, 10)
        .padding(.vertical, 8)
        .background(
            RoundCornerShape(corners: [.bottomLeft, .bottomRight], radius: 10)
                .fill(Color(hex: "948895"))
                .onTapGesture {
                    navigateAction()
                }
                .overlay(alignment: .trailing){
                    Menu {
                        Button("Rename", action: firstAction)
                        Button("Delete", action: secondAction)
                    }
                label: {
                    Rectangle()
                        .fill(.clear)
                        .frame(width: 20, height: 20,alignment: .center)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .foregroundStyle(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 3.75,alignment: .center)
                                .rotationEffect(Angle(degrees: 270))
                        }
                        .padding(.trailing,8)
                }
                }
        )
    }
}
