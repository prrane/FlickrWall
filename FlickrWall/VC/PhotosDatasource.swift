//
//  PhotosDatasource.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class PhotosDatasource: NSObject {

  fileprivate var kPhotosDatasourceContext = 1

  var datasourceUpdatedCallback: (() -> Void)?
  let searchManager = SearchManager()

  override init() {
    super.init()

    searchManager.keyword = "cat"
    SearchResultsCache.shared.addObserver(self, forKeyPath:#keyPath(SearchResultsCache.isUpdated), options: .new, context: &kPhotosDatasourceContext)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &kPhotosDatasourceContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    if keyPath == #keyPath(SearchResultsCache.isUpdated) {
      DispatchQueue.main.async { [weak self] in
        self?.datasourceUpdatedCallback?()
      }
    }
  }

}

// MARK:- UICollectionViewDataSource
extension PhotosDatasource: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return SearchResultsCache.shared.numberOfPhotos(for: section+1)
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SearchResultsCache.shared.numberOfPages()
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
    
    return cell
  }

}

// MARK:- UICollectionViewDataSourcePrefetching

extension PhotosDatasource: UICollectionViewDataSourcePrefetching {

  public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    guard let lastSection = indexPaths.last?.section else {
      return
    }

    let nextPage = lastSection + 2
    if SearchResultsCache.shared.shouldPredetch(forPage: nextPage) && nextPage > searchManager.currentPage {
      searchManager.getNextpage()
    }
  }

}
