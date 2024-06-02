import Foundation
struct Recipe: Codable {
    var id: Int?
    let author: String?
    let title: String
    let pictureUrl: String?
    var ingredients: [Ingredient]?
    var steps: [Step]?
    var videoUrl: String?
    var videoImageUrl: String?
    var videoTitle: String?
    var videoDuration: String?
    var videoChannelName: String?
    var videoPostedDate: String?
    let rating: Double?
    var time: Int?
    var isEditorChoice: Bool?
    var serving: Float?
    enum CodingKeys: String, CodingKey {
        case author, title, ingredients, steps, rating,id,time,serving
        case videoUrl = "video_url"
        case videoImageUrl = "video_image_url"
        case videoTitle = "video_title"
        case videoDuration = "video_duration"
        case videoChannelName = "video_channel_name"
        case videoPostedDate = "video_posted_date"
        case pictureUrl = "picture_url"
    }
}



struct RecipeWithCategories:Codable {
    var recipe: Recipe
    var categories: [Folder]
}


extension Recipe {
    static func dummyRecipes(count: Int) -> [Recipe] {
        (0..<count).map { _ in
            
            Recipe(id: UniqueIDGenerator.generate(),author: "", title: "Loading...",pictureUrl: "", ingredients: [], steps: [], videoUrl: nil, rating: 0, isEditorChoice: false, serving: 1)
        }
    }
}




