//
//  OnboardingModel.swift
//  Recipe Jar Onboarding
//
//  Created by Othman Shahrouri on 21/03/2024.
//

import Foundation
import SwiftUI
enum OnboardingModel: CaseIterable,Identifiable {
    case firstTab
    case secondTab
    case thirdTab
    
    var id: UUID {
        switch self {
        case .firstTab:
            return UUID()
        case .secondTab:
            return UUID()        
        case .thirdTab:
            return UUID()       
        }
    }
    
    var title: String {
        switch self {
        case .firstTab:
            return "Instantly save online recipes"
        case .secondTab:
            return "Cook without multitasking using hands-free control"
        case .thirdTab:
            return "Transform saved recipes into convenient shopping lists"
        }
    }

    var subtitles: [String] {
        switch self {
        case .firstTab:
            return ["Browse any recipe on Safari",
                    "Save directly to Recipe Jar using ",
                    "Start collecting your pocket recipes"]
        case .secondTab:
            return ["Follow the steps with a YouTube tutorial",
                    "Navigate between steps using your voice",
                    "Listen to the steps while cooking"]
        case .thirdTab:
            return ["Add the saved recipe’s ingredients directly",
                    "Customize your own shopping list",
                    "Create multiple shopping lists"]
        }
    }

    var images: [Image] { // Assuming image names are strings for placeholder purposes
        switch self {
        case .firstTab:
            return [Image("onboarding_tab_1_1"), Image("onboarding_tab_1_2"),Image("onboarding_tab_1_3")]
        case .secondTab:
            return [Image("onboarding_tab_2_1"), Image("onboarding_tab_2_2"),Image("onboarding_tab_2_3"),Image("onboarding_tab_2_4"),Image("onboarding_tab_2_5")]
        case .thirdTab:
            return [Image("onboarding_tab_3_1"), Image("onboarding_tab_3_2")]
        }
    }
}

