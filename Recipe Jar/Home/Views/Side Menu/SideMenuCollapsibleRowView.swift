//
//  SideMenuCollapsibleRowView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 23/03/2024.
//

import SwiftUI

struct SideMenuCollapsibleRowView: View {
    /// Customization Properties
    var hint: String
    var options: [Nameable]
    var optionsImage: Image
    var anchor: Anchor = .bottom
    var maxWidth: CGFloat = 180
    var cornerRadius: CGFloat = 15
    let tappedItem: (Nameable) -> ()
    
    /// View Properties
    @State private var showOptions: Bool = false

    /// Environment Scheme
    @Environment(\.colorScheme) private var scheme

    @State private var index: Double = 1000.0
    @State private var zIndex: Double = 1000.0
    private let horizontalSpacing = 15.0
    private let verticalPadding = 5.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: horizontalSpacing) {
                Image("side_menu_arrow")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24, alignment: .leading)
                    .foregroundStyle(Color(hex: "#232946"))
                    .rotationEffect(.init(degrees: showOptions ? 0 : 180))
                
                Text(hint)
                    .foregroundStyle(Color(hex: "#232946"))
                    .font(CustomFont.medium.font(size: 14))
                    .lineLimit(1)
            }
            .frame(width: maxWidth, height: 38, alignment: .leading)
            .background(scheme == .dark ? .black : .white)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.snappy) {
                    showOptions.toggle()
                }
            }
            .zIndex(10)

            if showOptions {
                SideMenuOptionsView(options: options, optionsImage: optionsImage, horizontalSpacing: horizontalSpacing, showOptions: $showOptions, tappedItem: tappedItem)
                    .transition(.move(edge: anchor == .top ? .bottom : .top))
            }
        }
        .clipped()
        /// Clips All Interaction within it's bounds
        .contentShape(.rect)
        .frame(width: maxWidth)
        .zIndex(zIndex)
        .background(.white)//scheme == .dark ? .black : .white)
    }

    enum Anchor {
        case top, bottom
    }
}
