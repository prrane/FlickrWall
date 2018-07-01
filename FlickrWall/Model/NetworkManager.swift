//
//  NetworkManager.swift
//  FlickrWall
//
//  Created by Prashant Rane on 30/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class NetworkManager {

  init() {

  }

  // Prepate the search request
  private func flickrURLRequest(for keyword: String) -> URLRequest? {
    let queryItems = [
      URLQueryItem(name: "method", value: "flickr.photos.search"),
      URLQueryItem(name: "api_key", value: "1f2d63bddf5c886d8ededcdcfbe8f40c"),
      URLQueryItem(name: "per_page", value: "2"),
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

  func fetchPhotos(for keyword: String, completion: @escaping (_ photos: [Photo], _ error: String?) -> Void) -> [URL] {

    guard let urlRequest = flickrURLRequest(for: keyword) else {
      return []
    }

    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        completion([], error!.localizedDescription)
        return
      }

      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        completion([], "Failed to get response from server, please try later")
        return
      }

      guard statusCode >= 200 && statusCode < 300 else {
        completion([], "Server request failed, please try later")
        return
      }

      guard let data = data else {
        completion([], "Failed to get images data from server, please try later")
        return
      }

      do {
        let photos = try JSONDecoder().decode(APIResponse.self, from: data)
        print(photos)
        completion([], nil)
      }
      catch let error {
        print(error)
        completion([], error.localizedDescription)
      }

    }.resume()

    return []
  }

}
