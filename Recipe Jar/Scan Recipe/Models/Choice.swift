//
//  Choice.swift
//  RecipeJarSnippets
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import Foundation
struct Choice: Decodable {
      struct Message: Decodable {
          let role: String
          let content: String
      }
      let index: Int
      let message: Message
  }
