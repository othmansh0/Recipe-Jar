import Foundation

class  ShoppingListCategory: Codable, ObservableObject, Nameable {
    let id: Int
    let icon: String?
    var name: String
    let numberOfItems: Int?
    var orderNumber: Int

    init(id: Int, name: String, icon: String?, numberOfItems: Int?, orderNumber: Int) {
        self.id = id
        self.name = name
        self.icon = icon
        self.numberOfItems = numberOfItems
        self.orderNumber = orderNumber
    }

    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case numberOfItems = "number_of_items"
        case orderNumber = "order_number"
    }
}

extension ShoppingListCategory {
    static func dummyCategories(count: Int) -> [ShoppingListCategory] {
        (0..<count).map { i in
            ShoppingListCategory(id: UniqueIDGenerator.generate() , name: "Dummy Cat \(i)", icon: "🗂️", numberOfItems: 4, orderNumber: i)
        }
    }
}



class UniqueIDGenerator {
    static func generate() -> Int {
        // Generate a UUID and use its hash value as a unique ID
        let uuid = UUID()
        return uuid.hashValue
    }
}

