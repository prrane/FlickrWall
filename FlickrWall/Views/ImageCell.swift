//
//  ImageCell.swift
//  FlickrWall
//
//  Created by Prashant Rane on 29/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

  struct Constants {
    static let placeHolderImage = UIImage(named: "loading")
  }

  static var reuseIdentifier: String {
    return String(describing: type(of: self))
  }

  let imageView: UIImageView = {
    let imageView: UIImageView = UIImageView(image: Constants.placeHolderImage)
    imageView.contentMode = .scaleAspectFit
    imageView.isHidden = true
    return imageView
  }()

  let loadingLabel: UILabel = {
    let loadingLabel = UILabel(frame: .zero)
    loadingLabel.textColor = .lightGray
    loadingLabel.font = .systemFont(ofSize: 16)
    loadingLabel.contentMode = .center
    loadingLabel.textAlignment = .center

    loadingLabel.text = NSLocalizedString("loading...", comment: "Placeholder string for till image is loaded")
    return loadingLabel
  }()

  //MARK: -
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white
    contentView.addSubview(imageView)
    contentView.addSubview(loadingLabel)
  }

  func setupWith(image: UIImage?) {
    guard let image = image else {
      imageView.image = nil
      imageView.isHidden = true
      loadingLabel.isHidden = false
      return
    }

    imageView.image = image
    imageView.isHidden = false
    loadingLabel.isHidden = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    loadingLabel.frame = contentView.frame.insetBy(dx: 5, dy: 5)
    imageView.frame = contentView.frame.insetBy(dx: 5, dy: 5)
  }

}
