//
//  FAQModel.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 09/05/2024.
//

import SwiftUI
struct FAQModel: Nameable {
    let id = UniqueIDGenerator.generate()
    let name: String
    let detail: String?
    var note: String?
//    var image: Image?
    let answers: [(String,[InlineSymbol]?,Image?)]
    
    
    static let questions = [
        FAQModel(name: "How can I import recipes from web to Recipe Jar?", detail: nil,note: "Note: If Recipe Jar fails to display after completing step 2, we recommend restarting your device and then repeating the process starting from step 1. This should resolve the issue and allow Recipe Jar to appear as expected.", answers: [
            ("Tap the Share icon at the bottom of your Safari page",nil,nil),
            ("Scroll through the apps and tap More",nil,Image("FAQ_more")),
            ("Select Recipe Jar",nil,nil),
            ("Make changes to your recipe details if needed",nil,nil),
            ("Hit Save at the top right corner",nil,nil),
        ]),
        
        FAQModel(name: "How can I set my second shopping list in the home screen widget?", detail: nil, answers: [
            ( "Tap the info icon at the top right corner of the widget",[InlineSymbol(name: "info.circle", accessibilityLabel: "info image",color: CustomColor.purple, position: 5)],nil),
            ("Choose the shopping list you'd like to see on your home screen.",nil,nil)]),
        
        FAQModel(name: "Why can’t I hear the steps of the recipe?",
                 detail: "it's possible that the app may not have access to your device's microphone, to resolve this:",
                 answers: [("Go to the Settings of your device",nil,nil),
                           ("Find and tap Recipe Jar",nil,nil),
                           ("Turn on the Microphone toggle",nil,nil)]
                ),
        
        FAQModel(name: "Can I restore my recipes if I delete the app?",
                 detail: "Yes Recipe Jar will sync in your recipes using iCloud which can be restored at any time you reinstall the app. To make sure you have it enabled:",
                 answers: [("Go to the Settings of your device",nil,nil),
                           ("Go to your Apple profile",nil,nil),
                           ("Go to iCloud",nil,nil),
                           ("Under the “Apps using iCloud” section, tap on Show All",nil,nil),
                           ("Look for Recipe Jar and make sure the toggle is enabled",nil,nil)
                          ]
                ),
        
        FAQModel(name: "What will Erase Data do exactly?", detail: nil, answers: [
            ("Erasing data will delete your profile locally from all devices and sign them out, removing all saved data. Upon logging in again, you will start with a new profile without any previous data.",nil,nil)])
    ]
}
