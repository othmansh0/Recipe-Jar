import Foundation
struct Step: Codable, Identifiable {
    var orderNumber: Int
    let id = UUID().uuidString
    var description: String
    
    init(description: String, orderNumber: Int) {
        self.description = description
        self.orderNumber = orderNumber
    }

    enum CodingKeys: String, CodingKey {
        case description
        case orderNumber = "order_number"
    }
}

extension Step {
    static func getDummyStep() -> [Step] {
        let steps = [Step(description: "Gather all the ingredients needed for the recipe.\nGather all the ingredients needed for the recipe.\nGather all the ingredients needed for the recipe.\nGather all the ingredients needed for the recipe.\nGather all the ingredients needed for the recipe.\nGather all the ingredients needed for the recipe.", orderNumber: 1)]
        return steps
    }
}
