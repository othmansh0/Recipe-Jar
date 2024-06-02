//
//  SideMenuFirstSectionView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 23/03/2024.
//

import SwiftUI

struct SideMenuFirstSectionView: View {
    @State private var showSafari = false
    @State private var sideMenuLink: SideMenuLink = .bmi
  
    var body: some View {
        VStack(alignment:.leading,spacing: 24) {
            SideMenuRowView(title: "BMI Calculator", image: Image("side_menu_BMI"), action: {
                sideMenuLink = .bmi
                showSafari = true
            })
            SideMenuRowView(title: "TDEE Calculator", image: Image("side_menu_TDEE"), action: {
                sideMenuLink = .TDEE
                showSafari = true
            })
        }
        .fullScreenCover(isPresented: $showSafari) {
            SafariView(url: URL(string: sideMenuLink.rawValue)!)
                            .edgesIgnoringSafeArea(.all)
        }
    }
}

enum SideMenuLink: String {
    case bmi = "https://www.calculator.net/bmi-calculator.html"
    case TDEE = "https://www.calculator.net/tdee-calculator.html"
}
