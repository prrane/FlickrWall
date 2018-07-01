//
//  SearchManager.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class SearchManager: NSObject {

  struct Constants {
    static let errorNotificationKey = "SearchOperationError"
    static let errorMessageKey = "errorMessage"
  }

  private let queue = AsyncQueue(named: "com.prrane.flickr.search")
  private var kSearchManagerContext = 1

  var keyword: String = "" {
    didSet {
      print("Now searching for: \(keyword)")
      currentPage = 0
      resetAndRestart()
    }
  }

  var currentPage: Int

  private var nextPage: Int {
    return currentPage + 1
  }

  override init() {
    currentPage = 0
  }

  func getNextpage() {
    currentPage = nextPage
    print("Fetching page: \(currentPage) | next : \(nextPage)")
    restart()
  }

  private func reset() {
    queue.cancelAllOperations()
    SearchResultsCache.shared.invalidateCache()
  }

  private func restart() {
    let searchOperation = SearchOperation(with: keyword, page: currentPage)
    searchOperation.addObserver(self, forKeyPath: #keyPath(SearchOperation.state), options: .new, context: &kSearchManagerContext)

    queue.addOperation(searchOperation)
  }

  private func resetAndRestart() {
    reset()
    restart()
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &kSearchManagerContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    guard let searchOperation = object as? SearchOperation else {
      return
    }

    guard keyPath == #keyPath(SearchOperation.state) else {
      return
    }

    guard let newValue = change?[NSKeyValueChangeKey.newKey] as? Int, newValue == AsyncOperation.State.finished.rawValue else {
      return
    }

    if let errorMessage = searchOperation.errorMessage {
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.errorNotificationKey), object: nil, userInfo: [Constants.errorMessageKey : errorMessage])
    }

    // Remove observer
    searchOperation.removeObserver(self, forKeyPath: #keyPath(SearchOperation.state))
  }

}
