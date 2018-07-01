//
//  NetworkManager.swift
//  FlickrWall
//
//  Created by Prashant Rane on 30/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class NetworkManager {

  static let shared = NetworkManager()
  
  // Prepate the search request
  private func flickrURLRequest(for keyword: String, page: Int = 1) -> URLRequest? {
    let queryItems = [
      URLQueryItem(name: "method", value: "flickr.photos.search"),
      URLQueryItem(name: "api_key", value: "1f2d63bddf5c886d8ededcdcfbe8f40c"),
      URLQueryItem(name: "per_page", value: "30"),
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "format", value: "json"),
      URLQueryItem(name: "tags", value: keyword),
      URLQueryItem(name: "nojsoncallback", value: "1"),
    ]

    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.flickr.com"
    components.path = "/services/rest/"
    components.queryItems = queryItems

    guard let url = components.url else {
      return nil
    }

    return URLRequest(url: url)
  }

  func fetchPhotos(for keyword: String, page: Int, completion: @escaping (_ response: APIResponse?, _ error: String?) -> Void) {

    guard let urlRequest = flickrURLRequest(for: keyword, page: page) else {
      return
    }

    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        completion(nil, error!.localizedDescription)
        return
      }

      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        completion(nil, "Failed to get response from server, please try later")
        return
      }

      guard statusCode >= 200 && statusCode < 300 else {
        completion(nil, "Server request failed, please try later")
        return
      }

      guard let data = data else {
        completion(nil, "Failed to get images data from server, please try later")
        return
      }

      do {
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        completion(apiResponse, nil)
      }
      catch let error {
        print(error)
        completion(nil, error.localizedDescription)
      }

    }.resume()
  }

}