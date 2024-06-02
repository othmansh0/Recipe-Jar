//
//  OnboardingGridView.swift
//  Recipe Jar Onboarding
//
//  Created by Othman Shahrouri on 21/03/2024.
//
import Combine
import SwiftUI

struct OnboardingGridView: View {
    
    var tabType: OnboardingModel
    var namespace: Namespace.ID
    @Binding var showFeaturesView: Bool
    
    var body: some View {
        ZStack {
            if tabType == .firstTab {
                SequentialGridView1(images: tabType.images, showFeaturesView: $showFeaturesView)
            }
            else if tabType == .secondTab {
                SequentialGridView2(images: tabType.images, showFeaturesView: $showFeaturesView)
            }
            
            else if tabType == .thirdTab {
                SequentialGridView3(images: tabType.images, showFeaturesView: $showFeaturesView)
            }
        }
        
    }
}









