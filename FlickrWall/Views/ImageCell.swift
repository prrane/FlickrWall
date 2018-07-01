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

  var id: String? = nil

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
    contentView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
    contentView.layer.borderWidth = 1.0 / UIScreen.main.scale
    
    contentView.addSubview(imageView)
    contentView.addSubview(loadingLabel)
  }

  override func prepareForReuse() {
    imageView.image = nil
    imageView.isHidden = true
    loadingLabel.isHidden = false
    self.id = nil
  }

  func setupWith(image: UIImage?, id: String) {
    self.id = id
    
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

  func setupWith(image: UIImage) {
    if let photoId = id {
      setupWith(image: image, id: photoId)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    loadingLabel.frame = contentView.frame
    imageView.frame = contentView.frame.insetBy(dx: 5, dy: 5)
  }

}
