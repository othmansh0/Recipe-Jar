//
//  TagView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 30/12/2023.
//

import SwiftUI
struct TagView: View {
    let title:String
    let foregroundColor:UIColor
    let fillColor:UIColor
    var borderColor:UIColor?
    var boderWidth: CGFloat?
    var verticalPadding:CGFloat?
    var horizontalPadding:CGFloat?
    var tagFont: Font?
    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(tagFont ?? CustomFont.bold.font(size: 13))
                .foregroundColor(Color(uiColor: foregroundColor))
                .multilineTextAlignment(.trailing)
        }
        .modifier(ChipModifier(color:Color(uiColor: fillColor),verticalPadding: verticalPadding ,horizontalPadding: horizontalPadding))
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color(uiColor: borderColor ?? fillColor), lineWidth: boderWidth ?? 0)
                .padding(1) // Add padding to prevent border clipping
        )
    }
}
struct ChipModifier: ViewModifier {
    let color:Color
    var verticalPadding:CGFloat?
    var horizontalPadding:CGFloat?
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, verticalPadding ?? 4)
            .padding(.horizontal, horizontalPadding ?? 12)
            .background(color)
            .cornerRadius(100)
    }
}
