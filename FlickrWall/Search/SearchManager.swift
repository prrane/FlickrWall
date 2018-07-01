//
//  SearchManager.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class SearchManager {

  private let queue = SearchQueue()

  var keyword: String = "" {
    didSet {
      queue.cancelAllOperations()
      let searchOperation = SearchOperation(with: keyword)
      queue.addOperation(searchOperation)
    }
  }

  var currentPage: Int

  private var nextPage: Int {
    return currentPage + 1
  }

  init() {
    currentPage = 0
  }

  func getNextpage() {

    currentPage = nextPage

    print("Fetching page: \(currentPage) | next : \(nextPage)")

    let searchOperation = SearchOperation(with: keyword, page: currentPage)
    queue.addOperation(searchOperation)
  }

}
