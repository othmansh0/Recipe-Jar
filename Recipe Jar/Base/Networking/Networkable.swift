import Combine
import Foundation
import Combine
import Foundation

public protocol Networkable {
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
    func sendRequest(endpoint: EndPoint) async throws
}

public final class NetworkService: Networkable {
    public func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
          guard let urlRequest = createRequest(endPoint: endpoint) else {
              throw NetworkError.badURL
          }

          // Debug: Print URL and HTTP Headers
          print("---- URL Request Details ----")
          print("URL: \(urlRequest.url?.absoluteString ?? "Invalid URL")")
          print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
          if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
              print("Body: \(bodyString)")
          }

          return try await withCheckedThrowingContinuation { continuation in
              let task = URLSession(configuration: .default).dataTask(with: urlRequest) { data, response, error in
                  if let error = error as? URLError {
                      continuation.resume(throwing: NetworkError.url(error))
                      return
                  }

                  guard let httpResponse = response as? HTTPURLResponse else {
                      continuation.resume(throwing: NetworkError.badURL)
                      return
                  }

                  guard 200...299 ~= httpResponse.statusCode else {
                      continuation.resume(throwing: NetworkError.badResponse(statusCode: httpResponse.statusCode))
                      return
                  }

                  guard let data = data else {
                      continuation.resume(throwing: NetworkError.unknown)
                      return
                  }
                  print("response is \(response)")
                  print("data is \(String(data:data,encoding: .utf8))")
                  do {
                      let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                      continuation.resume(returning: decodedResponse)
                  } catch let decodingError as DecodingError {
                      continuation.resume(throwing: NetworkError.parsing(decodingError))
                  } catch {
                      continuation.resume(throwing: NetworkError.unknown)
                  }
              }
              task.resume()
          }
      }

      public func sendRequest(endpoint: EndPoint) async throws {
          guard let urlRequest = createRequest(endPoint: endpoint) else {
              throw NetworkError.badURL
          }

          // Debug: Print URL and HTTP Headers
          print("---- URL Request Details ----")
          print("URL: \(urlRequest.url?.absoluteString ?? "Invalid URL")")
          print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
          if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
              print("Body: \(bodyString)")
          }

          let (data, response) = try await URLSession.shared.data(for: urlRequest)
          print("response is \(response)")
          print("data is \(data)")
          guard let httpResponse = response as? HTTPURLResponse else {
              throw NetworkError.badURL
          }

          guard 200...299 ~= httpResponse.statusCode else {
              throw NetworkError.badResponse(statusCode: httpResponse.statusCode)
          }

          // Request completed successfully with no further processing needed.
      }
}

extension Networkable {
    fileprivate func createRequest(endPoint: EndPoint) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems

        guard let url = urlComponents.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header

        if let body = endPoint.body, endPoint.method != .get {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error encoding request body: \(error)")
                return nil
            }
        }

        // Debug: Print URL components
        print("---- URL Components ----")
        print("Scheme: \(urlComponents.scheme ?? "N/A")")
        print("Host: \(urlComponents.host ?? "N/A")")
        print("Path: \(urlComponents.path)")
        print("Query Items: \(urlComponents.queryItems ?? [])")

        return request
    }
}
