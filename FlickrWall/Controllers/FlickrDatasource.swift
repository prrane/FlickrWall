//
//  FlickrDatasource.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class FlickrDatasource: NSObject {

  // KVO
  private var kFlickrDatasourceContext = 1

  // ivars to be set during initialization
  var datasourceUpdatedCallback: (() -> Void)?
  var searchBarDelegateProxy: UISearchBarDelegate?

  let searchManager = SearchManager()
  let photoManager = PhotoDownloadManager()

  //MARK: -
  
  override init() {
    super.init()

    // init with some default search keyword
    searchManager.keyword = "cat"
    SearchResultsCache.shared.addObserver(self, forKeyPath:#keyPath(SearchResultsCache.isUpdated), options: .new, context: &kFlickrDatasourceContext)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &kFlickrDatasourceContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    if keyPath == #keyPath(SearchResultsCache.isUpdated) {
      DispatchQueue.main.async { [weak self] in
        self?.photoManager.okToProceed = true
        self?.datasourceUpdatedCallback?()
      }
    }
  }
}


//MARK:- UICollectionViewDataSource

extension FlickrDatasource: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return SearchResultsCache.shared.numberOfPhotos(for: section+1)
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return SearchResultsCache.shared.numberOfPages()
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell

    guard let photo = SearchResultsCache.shared.item(forIndexPath: indexPath) else {
      return cell
    }

    guard let image = PhotosCache.shared.photo(for: photo.id) else {
      cell.setupWith(image: nil, id: photo.id)
      photoManager.downloadPhoto(with: photo)
      return cell
    }

    cell.setupWith(image: image, id: photo.id)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard indexPath.section == 0,  kind == UICollectionElementKindSectionHeader else {
      return UICollectionReusableView()
    }

    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchBarHeaderView.reuseIdentifier, for: indexPath) as! SearchBarHeaderView
    headerView.setup(withDelegate: self)

    return headerView
  }

}


//MARK:- UICollectionViewDataSourcePrefetching

extension FlickrDatasource: UICollectionViewDataSourcePrefetching {

  public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    guard let lastSection = indexPaths.last?.section else {
      return
    }

    // Page is section + 1; we want next section
    let nextPage = lastSection + 2

    if SearchResultsCache.shared.shouldPredetch(forPage: nextPage) && nextPage > searchManager.currentPage {
      searchManager.getNextpage()
    }
  }

}


//MARK:- UISearchBarDelegate

extension FlickrDatasource: UISearchBarDelegate {

  public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBarDelegateProxy?.searchBarCancelButtonClicked?(searchBar)
  }

  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let text = searchBar.text {
      photoManager.cancelAllOperations(shouldResetCache: true)
      searchManager.keyword = text
    }

    searchBar.resignFirstResponder()
    searchBarDelegateProxy?.searchBarSearchButtonClicked?(searchBar)
  }

}
