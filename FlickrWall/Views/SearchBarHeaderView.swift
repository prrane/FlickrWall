//
//  SearchBarHeaderView.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class SearchBarHeaderView: UICollectionReusableView {

  struct Constants {
    static let defaultHeight: CGFloat = 44.0
  }

  static var reuseIdentifier: String {
    return String(describing: type(of: self))
  }

  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchBarStyle = .minimal
    searchBar.showsCancelButton = true
    searchBar.placeholder = NSLocalizedString("Enter keywords e.g. cat, sunrise", comment: "Placeholder text for search bar")
    return searchBar
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(searchBar)
  }

  func setup(withDelegate delegate: UISearchBarDelegate?) {
    searchBar.delegate = delegate
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    searchBar.frame = frame.insetBy(dx: 0, dy: 5)
  }
}
