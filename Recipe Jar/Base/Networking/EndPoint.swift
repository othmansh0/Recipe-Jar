import Foundation

public protocol EndPoint {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
}


extension EndPoint {
    var scheme: String {
        return "https"
    }
    var host: String {
        return ""
    }
}
