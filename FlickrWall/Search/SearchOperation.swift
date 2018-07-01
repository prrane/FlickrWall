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
    NetworkManager.shared.fetchPhotos(for: keyword, page: currentPage) { (response: APIResponse?, error: String?) in

      self.state = .finished

      guard error == nil else {
        return
      }

      guard let response = response, response.errorCode == nil else {
        return
      }

      guard let searchResults = response.results else {
        return
      }

      print("Fetched page: \(searchResults.currentPage), total : \(searchResults.totalPages)")

      SearchResultsCache.shared.add(results: searchResults)      
    }
  }

}
