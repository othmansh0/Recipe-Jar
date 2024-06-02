import Foundation
struct ShoppingListItem: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    var isCheck: Bool
//    var orderNumber: Int

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isCheck = "is_check"
//        case orderNumber = "order_number"
    }
}
extension ShoppingListItem {
    static func dummyItems(count: Int) -> [ShoppingListItem] {
        (0..<count).map { i in
            ShoppingListItem(id: UniqueIDGenerator.generate(), name: "Loading...", isCheck: false)
        }
    }
}



