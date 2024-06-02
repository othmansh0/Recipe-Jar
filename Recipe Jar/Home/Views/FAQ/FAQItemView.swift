//
//  FAQItemView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/04/2024.
//

import SwiftUI

struct FAQItemView: View {
    /// Customization Properties
  
    let question: FAQModel
    var anchor: Anchor = .bottom
    var cornerRadius: CGFloat = 15
    let forceExpandQ: Bool
    let tappedItem: (Nameable) -> ()
    
    /// View Properties
    @State private var showOptions: Bool = false


    @State private var index: Double = 1000.0
    @State private var zIndex: Double = 1000.0
   
    private let verticalSpacing = 10.0
    private let verticalPadding = 5.0
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(question.name)
                        .foregroundStyle(Color(hex: "#232946"))
                        .font(CustomFont.medium.font(size: 14))
                    Spacer()
                    Image("side_menu_arrow")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16, alignment: .leading)
                        .foregroundStyle(Color(hex: "#7F5283"))
                        .rotationEffect(.init(degrees: showOptions ? 0 : 180))
                }
                .padding(.leading,22)
                .padding(.trailing,12)
                .padding(.vertical,12)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .onTapGesture {
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .onAppear {
                    withAnimation(.snappy.delay(0.2)) {
                        if forceExpandQ { showOptions.toggle() }
                    }
                }
                if showOptions {
                    OptionsView(question: question,showOptions: $showOptions)
                        .transition(.move(edge: anchor == .top ? .bottom : .top).combined(with: .opacity).animation(.easeOut(duration: 0.1)))
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "7F5283", opacity: 0.08))
            )
            .clipped()
            /// Clips All Interaction within it's bounds
            .contentShape(.rect)
        }
    }
    
    enum Anchor {
        case top, bottom
    }
}


#Preview {
Text(AttributedString( "This is a star: \(Image(systemName: "star.fill")) and here is a heart: \(Image(systemName: "heart.fill"))"))
}
