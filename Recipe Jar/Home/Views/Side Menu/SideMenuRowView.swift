//
//  SideMenuRowView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 23/03/2024.

import SwiftUI
struct SideMenuRowView: View {
    let title: String
    let image: Image
    let action: (() -> ())?
    var body: some View {
        HStack(spacing: 10){
            image
                .resizable()
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color(hex: "#232946"))
                .frame(width: 24, height: 24)
            Text(title)
                .foregroundStyle(Color(hex:"#232946"))
                .font(CustomFont.medium.font(size: 14))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            (action ?? {})()
        }
    }
}


