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

  struct Constants {
    static let defaultNumberOfRows = 15
  }

  //MARK: -

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = ImageCollectionView(with: self, delegate: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    cellSize = updatedItemSize()
    title = NSLocalizedString("Flickr Feed", comment: "Main screen title for flickr app") 
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    cellSize = updatedItemSize()
  }

  private func updatedItemSize() -> CGSize {
    let maxCellsPerRow = CGFloat(ImageCollectionView.Constants.maxCellsPerRow)
    let maxPaddingPerRow = ImageCollectionView.Constants.minimumXPadding * (maxCellsPerRow - 1)
    let imageHeight = floor((UIScreen.main.bounds.width - maxPaddingPerRow) / maxCellsPerRow)

    return CGSize(width: imageHeight, height: imageHeight)
  }

}

//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Constants.defaultNumberOfRows
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
    
    return cell
  }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return cellSize
  }
  
}
