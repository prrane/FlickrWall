//
//  SearchOperation.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class SearchOperation: AsyncOperation {

  let currentPage: Int
  let keyword: String
  var errorMessage: String?

  init(with keyword: String, page: Int = 0)  {
    self.keyword = keyword
    self.currentPage = page
  }

  override func start() {
    print("Search: Operation Started for \(keyword)")

    guard !self.isCancelled else {
      print("Search: Marked as finished because it is cancelled for \(keyword)")
      self.state = .finished
      return
    }

    state = .executing
    execute()
  }

  private func execute() {
    fetchPhotos(for: keyword, page: currentPage) { [weak self] (response: APIResponse?, error: String?) in

      guard error == nil else {
        self?.errorMessage = "Error while searching: \(error!)"
        self?.state = .finished
        return
      }

      guard response != nil, response?.errorCode == nil else {
        self?.errorMessage = "Search failed with error code: \(String(describing: response?.errorCode!))"
        self?.state = .finished
        return
      }

      guard let searchResults = response?.results else {
        self?.errorMessage = "No search results returned for keyword: \(String(describing: self?.keyword))"
        self?.state = .finished
        return
      }

      print("Fetched page: \(searchResults.currentPage), total pages: \(searchResults.totalPages)")

      SearchResultsCache.shared.add(results: searchResults)
      self?.state = .finished
    }
  }

}

//MARK: - Download Helpers
extension SearchOperation {

  // Prepate the search request
  private func flickrURLRequest(for keyword: String, page: Int = 1) -> URLRequest? {
    let queryItems = [
      URLQueryItem(name: "method", value: "flickr.photos.search"),
      URLQueryItem(name: "api_key", value: "1f2d63bddf5c886d8ededcdcfbe8f40c"),
      URLQueryItem(name: "per_page", value: "21"),
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

  private func fetchPhotos(for keyword: String, page: Int, completion: @escaping (_ response: APIResponse?, _ error: String?) -> Void) {

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
