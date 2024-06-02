//
//  IngredientView.swift
//  Recipe Jar
//
//  Created by Othman Shahrouri on 30/12/2023.
//

import SwiftUI
struct IngredientView: View {
    
    let ingredient: Ingredient
    @Binding var selectedIngredientName: String
    var scale:Double
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                //MARK: ingredient
                Button {
                    action()
                    selectedIngredientName = ingredient.name
                } label: {
                    Image("plusbutton")
                }
                .padding(.trailing,5)
                Group {
                    if ingredient.quantity == nil || ingredient.unit == nil ||  ingredient.quantity == 0{
                        Text(" - ")
                            .foregroundColor(CustomColor.yellow)
                    }
                    else {
                        if let quantity = ingredient.quantity {
                            Text(String(format: "%.2f", quantity*scale).trimmedAndCleaned())
                                .foregroundColor(CustomColor.yellow)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
                .frame(width:45)
                Spacer()
                
                HStack {
                    if let unit = ingredient.unit, !unit.isEmpty{
                        if let first = unit.split(separator: " ").first {
                            Text(first)
                                .foregroundColor(Color(uiColor: .navy))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    Text(ingredient.name)
                        .foregroundColor(Color(uiColor: .navy))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image("ingarrow")
            }
            Divider()
        }
    }
}
