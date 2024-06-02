//
//  FeaturesView.swift
//  Recipe Jar Onboarding
//
//  Created by Othman Shahrouri on 22/03/2024.
//

import SwiftUI
struct FeaturesView: View {
    let title: String
    let features: [String]
    var body: some View {
        VStack(alignment:.leading,spacing: 25) {
            Text(title)
                .font(CustomFont.medium.font(size: 24))
            
            VStack(alignment:.leading,spacing: 8) {
                ForEach(features,id: \.self) { feature in
                    HStack(spacing: 6){
                        Text("✨")
                        Text(feature)
                        if feature.contains("Save directly to Recipe Jar"){
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 14, height: 19)
                                .foregroundStyle(Color(red: 0.18, green: 0.49, blue: 0.96))
                        }
                    }
                    .font(CustomFont.regular.font(size: 16))
                    .foregroundStyle(Color(red: 0.434, green: 0.434, blue: 0.434))
                }
            }
        }
    }
}




