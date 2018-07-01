//
//  MainViewController.swift
//  FlickrWall
//
//  Created by Prashant Rane on 29/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

  var cellSize: CGSize = .zero
  let datasource = PhotosDatasource()
  private var kMainViewControllerContext = 1

  struct Constants {
    static let defaultNumberOfRows = 15
  }

  //MARK: -

  private var imageCollectionView: ImageCollectionView {
    return view as! ImageCollectionView
  }

  init() {
    super.init(nibName: nil, bundle: nil)

    datasource.datasourceUpdatedCallback = reload
    datasource.searchBarDelegateProxy = self

    NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.showError(notification:)), name: NSNotification.Name(rawValue: SearchManager.Constants.errorNotificationKey), object: nil)
    PhotosCache.shared.addObserver(self, forKeyPath: #keyPath(PhotosCache.downloaded), options: .new, context: &kMainViewControllerContext)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = ImageCollectionView(withDataSource: datasource, delegate: self, prefetchDataSource: datasource)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    cellSize = updatedItemSize()
    title = NSLocalizedString("Flickr Feed", comment: "Main screen title for flickr app")

    imageCollectionView.scrollToFirstRow()
  }

  func reload() {
    imageCollectionView.reload()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

    // Clear all photos
    PhotosCache.shared.invalidateCache()
  }

  @objc func showError(notification: Notification) {
    guard let errorMessage = notification.userInfo?[SearchManager.Constants.errorMessageKey] as? String else {
      return
    }

    let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Title for OK button from error alert"), style: UIAlertActionStyle.default, handler: nil))

    present(alert, animated: true, completion: nil)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &kMainViewControllerContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    if keyPath == #keyPath(PhotosCache.downloaded) {
      guard let photoId = change?[NSKeyValueChangeKey.newKey] as? String else {
        return
      }

      DispatchQueue.main.async {
        self.setupCell(with: photoId)
      }
    }
  }

  func setupCell(with photoId: String) {
    guard let image = PhotosCache.shared.photo(for: photoId) else {
      return
    }

    imageCollectionView.setupCell(with: photoId, image: image)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    cellSize = updatedItemSize()
  }

  private func updatedItemSize() -> CGSize {
    let maxCellsPerRow = CGFloat(ImageCollectionView.Constants.maxCellsPerRow)
    let maxPaddingPerRow = ImageCollectionView.Constants.minimumPadding * (maxCellsPerRow - 1)
    let imageHeight = floor((UIScreen.main.bounds.width - maxPaddingPerRow) / maxCellsPerRow)

    return CGSize(width: imageHeight, height: imageHeight)
  }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return cellSize
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: ImageCollectionView.Constants.minimumPadding, left: 0, bottom: 0, right: 0)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    guard section == 0 else {
      return .zero
    }

    return CGSize(width: collectionView.frame.size.width, height: SearchBarHeaderView.Constants.defaultHeight)
  }
}

extension MainViewController: UISearchBarDelegate {

  public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    imageCollectionView.scrollToFirstRow()
  }

  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    imageCollectionView.scrollToFirstRow()
  }

}

