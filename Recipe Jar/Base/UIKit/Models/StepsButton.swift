//
//  StepsButton.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 26/01/2024.
//

import UIKit
enum StepsButton: CaseIterable {
    case ingredients
    case youtube
    case textToSpeech
    case voiceCommands
    
    var buttonImage: UIImage {
        switch self {
        case .ingredients:
            return UIImage(named: "ingredients_icon")!
        case .youtube:
            return UIImage(named: "youtube_icon")!
        case .textToSpeech:
            return UIImage(named: "text_to_speech_icon")!
        case .voiceCommands:
            return UIImage(named: "voice_commands_icon")!
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .ingredients:
            return CGSize(width: 18.2, height: 18.2)
        case .youtube:
            return CGSize(width: 16.6, height: 11.7)
        case .textToSpeech:
            return CGSize(width: 18, height: 18)
        case .voiceCommands:
            return CGSize(width: 16, height: 18)
        }
    }
}
