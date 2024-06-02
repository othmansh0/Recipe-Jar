import Foundation
struct VideoURL: Codable {
    var youtubeLink: String?
    var title: String?
    var image: String?
    var channelName: String?
    var duration: String?
    var videoPostedDate: String?

    enum CodingKeys: String, CodingKey {
        case youtubeLink = "youtube_link"
        case title
        case image
        case channelName = "channel_name"
        case duration
        case videoPostedDate = "video_posted_date"
    }
}
