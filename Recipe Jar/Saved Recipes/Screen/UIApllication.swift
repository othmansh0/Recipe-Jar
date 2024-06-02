//
//  UIApllication.swift
//  Recipe Jar
//
//  Created by othman shahrouri on 2/23/23.
//


import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing () {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
