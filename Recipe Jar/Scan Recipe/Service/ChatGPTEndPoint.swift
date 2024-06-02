//
//  File.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 15/05/2024.
//

import Foundation
enum ChatGPTEndPoint {
    case convertRecipe(recipeText: String)
}

extension ChatGPTEndPoint: EndPoint {
    var method: RequestMethod {
        switch self {
        case .convertRecipe:
            return .post
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .convertRecipe(let recipeText):
            return [
                           "model": "gpt-3.5-turbo",
                           "messages": [
                               ["role": "system", "content": """
                               You are a helpful assistant that converts scanned recipe text into a structured JSON format. The JSON should include the following structure:
                               {
                                 "recipe": {
                                   "title": "String",
                                   "recipe_category": "String",
                                   "picture_url": "String",
                                   "ingredients": [
                                     {
                                       "name": "String",
                                       "quantity": Double,
                                       "unit": "String",
                                       "order_number": Int
                                     }
                                   ],
                                   "steps": [
                                     {
                                       "description": "String",
                                       "order_number": Int
                                     }
                                   ],
                                   "rating": Double
                                 },
                                 "categories": [
                                   {
                                     "id": Int,
                                     "name": "String",
                                     "order_number": Int,
                                     "number_of_items": Int,
                                     "recently_recipes_added": ["String"]
                                   }
                                 ]
                               }
                               Return the JSON directly in your response content without any escaping or extra characters.For categories return an empty array
                               """],
                               ["role": "user", "content": recipeText]
                           ]
                       ]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var host: String {
        return "api.openai.com"
    }
    
    var scheme: String {
        return "https"
    }
    
    var path: String {
        return "/v1/chat/completions"
    }
    
    
    var header: [String: String]? {
        return [
            "Authorization": "Bearer dummy api here",
            "Content-Type": "application/json"
        ]
    }
}

