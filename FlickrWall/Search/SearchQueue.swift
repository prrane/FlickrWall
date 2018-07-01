//
//  SearchQueue.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

public class SearchQueue {
  private let operationQueue = OperationQueue()

  init () {
    operationQueue.maxConcurrentOperationCount = 1
    operationQueue.qualityOfService = .userInteractive
    operationQueue.name = "Search Queue"
  }

  func cancelAllOperations() {
    operationQueue.cancelAllOperations()
  }

  func addOperation(_ searchOperation: SearchOperation) {
    operationQueue.addOperation(searchOperation)
  }

}
