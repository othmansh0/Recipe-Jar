//
//  SideMenuHelpView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 23/03/2024.
//

import SwiftUI
struct SideMenuHelpView: View {
    let openHelpScreen: () -> Void
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "questionmark.circle")
                .resizable()
                .frame(width: 24, height: 24)
            Text("Help")
                .font(CustomFont.medium.font(size: 14))
        }
        .foregroundStyle(Color(hex: "#232946"))
        .onTapGesture {
            openHelpScreen()
        }
    }
}


