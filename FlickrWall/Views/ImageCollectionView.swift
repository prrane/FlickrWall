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
    static let minimumXPadding: CGFloat = 5.0
    static let maxCellsPerRow: Int = 3
  }

  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = Constants.minimumXPadding
    layout.minimumLineSpacing = Constants.minimumXPadding
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)

    return collectionView
  }()

  //MARK: -
  
  init(with dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
    super.init(frame: .zero)

    addSubview(collectionView)
    collectionView.dataSource = dataSource
    collectionView.delegate = delegate
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    collectionView.frame = frame
  }

}