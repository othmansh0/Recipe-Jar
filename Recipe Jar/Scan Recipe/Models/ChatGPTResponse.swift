//
//  ChatGPTResponse.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 14/05/2024.
//
import Foundation
struct ChatGPTResponse: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
}
extension ChatGPTResponse {
    func extractContent() -> String? {
        return choices.first?.message.content
    }
}
