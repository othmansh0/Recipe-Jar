import Foundation
class Ingredient: Codable {
    var name: String
    var quantity: Double?
    var unit: String?
    var orderNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case quantity, unit ,name
        case orderNumber = "order_number"
    }

    init(name: String, orderNumber: Int, quantity: Double = 0.0, unit: String? = nil) {
        self.name = name
        self.orderNumber = orderNumber
        self.quantity = quantity
        self.unit = unit
    }
}


extension Ingredient {
    static func getDummyIngredients() -> [Ingredient] {
        let ingredients = [
            Ingredient(name: "Flour", orderNumber: 1, quantity: 2.0, unit: "cups"),
            Ingredient(name: "Sugar", orderNumber: 2, quantity: 1.5, unit: "cups"),
            Ingredient(name: "Baking Powder", orderNumber: 3, quantity: 0.5, unit: "teaspoons"),
            Ingredient(name: "Salt", orderNumber: 4, quantity: 0.25, unit: "teaspoons"),
            Ingredient(name: "Milk", orderNumber: 5, quantity: 1.0, unit: "cups"),
            Ingredient(name: "Egg", orderNumber: 6, quantity: 2.0, unit: "large"),
            Ingredient(name: "Butter", orderNumber: 7, quantity: 0.5, unit: "cups"),
            Ingredient(name: "Vanilla Extract", orderNumber: 8, quantity: 2.0, unit: "teaspoons")
        ]
        return ingredients
    }
}
