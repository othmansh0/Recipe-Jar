//
//  IndicatorsView.swift
//  Recipe Jar Onboarding
//
//  Created by Othman Shahrouri on 21/03/2024.
//

import SwiftUI

struct IndicatorsView: View {
    let currentTabIndex: Int
    var totalIndices: Int
    let selectedIndicatorSize: CGSize
    let unSelectedIndicatorSize: CGSize
    let indicatorColor: Color
    
    let namespace: Namespace.ID
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalIndices, id: \.self) { i in
                if i == currentTabIndex {
                    Capsule()
                        .matchedGeometryEffect(id: "page", in: namespace)
                        .frame(width: selectedIndicatorSize.width, height: selectedIndicatorSize.height)
                        .scaleEffect(1.0)
                        .opacity(1.0)
                } else {
                    Capsule()
                        .frame(width: unSelectedIndicatorSize.width, height: unSelectedIndicatorSize.height)
                        .scaleEffect(0.7)
                        .opacity(0.35)
                }
            }
        }
        .foregroundColor(indicatorColor)
        .padding(.bottom, 10)
        .animation(.easeInOut(duration: 0.12), value: currentTabIndex)
    }
}

