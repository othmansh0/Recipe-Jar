//
//  AlertMessage.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import Foundation
struct AlertMessage: Identifiable {
    var id = UUID()
    let title: String
    let message: String
}
