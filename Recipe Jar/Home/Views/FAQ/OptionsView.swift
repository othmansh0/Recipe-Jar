//
//  OptionsView.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 15/04/2024.
//

import SwiftUI
struct OptionsView: View {
    
    let question: FAQModel
    @Binding var showOptions: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0) {
                if let detail = question.detail {
                    Text(detail)
                        .foregroundStyle(.black)
                        .font(CustomFont.regular.font(size: 14))
                        .padding(.horizontal,22)
                }
                ForEach(Array(question.answers.enumerated()), id: \.0) { (index,option) in
                    
                    VStack(spacing: 0) {
                        HStack(alignment:.top,spacing: 8) {
                            Text("\(index + 1).")
                                .font(CustomFont.regular.font(size: 12))
                            Group {
                                if let inlineSymbols = option.1{
                                    TextWithSFSymbolView(
                                        text: option.0,
                                        symbols:inlineSymbols
                                    )
                                }
                                else {
                                    Text(option.0)
                                }
                            }
                            .foregroundStyle(.black)
                            .font(CustomFont.regular.font(size: 14))
                        }
                        .frame(maxWidth:.infinity,alignment: .leading)
                        
                        if let image = option.2 {
                            image
                                .resizable()
                                .aspectRatio(3.21794872, contentMode: .fill)
                                .padding(.horizontal,22)
                                .padding(.vertical,4)
                        }
                    }
                    .padding(.horizontal,22)
                    .contentShape(Rectangle())
                    .onTapGesture { withAnimation(.snappy) { showOptions = false } }
                }
                
                if let note = question.note {
                    Text(note)
                        .foregroundStyle(.black)
                        .font(CustomFont.regular.font(size: 14))
                        .padding(.horizontal,22)
                        .padding(.top,10)
                }
            }
            .padding(.vertical,16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
            )
            .padding(.horizontal,6)
            .padding(.bottom, 6)
        }
    }
}
