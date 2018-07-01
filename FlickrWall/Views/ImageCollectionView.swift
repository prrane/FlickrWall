//
//  ImageCollectionView.swift
//  FlickrWall
//
//  Created by Prashant Rane on 29/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class ImageCollectionView: UIView {

  struct Constants {
    static let minimumPadding: CGFloat = 5.0
    static let maxCellsPerRow: Int = 3
  }

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = Constants.minimumPadding
    layout.minimumLineSpacing = Constants.minimumPadding

    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
    collectionView.backgroundColor = .white
    return collectionView
  }()

  //MARK: -
  
  init(withDataSource dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate, prefetchDataSource: UICollectionViewDataSourcePrefetching?) {
    super.init(frame: .zero)

    addSubview(collectionView)
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
    collectionView.prefetchDataSource = prefetchDataSource
  }

  func setupCell(with photoId: String, image: UIImage) {
    let filteredCells = collectionView.visibleCells.filter { ($0 as! ImageCell).id == photoId }
    guard let cell = filteredCells.first as? ImageCell else {
      return
    }

    cell.setupWith(image: image)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func reload() {
    collectionView.reloadData()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    collectionView.frame = frame
  }

}
