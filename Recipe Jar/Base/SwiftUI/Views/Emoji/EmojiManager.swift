import Foundation
//A class responsible for decoding emojis data from a JSON file
//Saved in recipe jar app project
class EmojiManager: ObservableObject {

    @Published var emojis: [EmojiObject] = []

    init() {
        decodeJSON()
    }
    
    func decodeJSON() {
        if let url = Bundle.main.url(forResource: "emoji", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let emoji: [EmojiObject] = try! JSONDecoder().decode([EmojiObject].self, from: data)
                self.emojis = emoji
            } catch {
            }
        }
    }
}

struct EmojiObject: Decodable, Hashable, Identifiable {
    let codes, char, name, category: String
    let subgroup: String
    let group: EmojiGroup
    var id: String { codes }
}

enum EmojiGroup: String, CaseIterable, Codable, Identifiable {
    case smileys = "Smileys & Emotion"
    case people = "People & Body"
    case component = "Component"
    case animals = "Animals & Nature"
    case foodAndDrink = "Food & Drink"
    case travel = "Travel & Places"
    case activities = "Activities"
    case objects = "Objects"
    case symbols = "Symbols"
    case flags = "Flags"

    var id: String { rawValue }
}
