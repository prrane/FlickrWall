//
//  PhotosCache.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import UIKit

class PhotosCache: NSObject {

  static let shared = PhotosCache()
  private var cache = [String: UIImage?]()
  private let cacheQueue = DispatchQueue(label: "com.prrane.flickr.photo.update.cache")

  @objc open dynamic var downloaded: String = "" {
    willSet {
      willChangeValue(forKey: "isDownloaded")
    }
    didSet {
      didChangeValue(forKey: "isDownloaded")
    }
  }

  func invalidateCache() {
      cache.removeAll()
  }

  func add(data: Data?, for id: String) {
    var image: UIImage? = nil
    if data != nil {
      image = UIImage(data: data!)
    }
    
    cache[id] = image
    downloaded = id
  }

  func photo(for id: String) -> UIImage? {
    guard let cachedImage = cache[id] else {
      return nil
    }

    return cachedImage
  }
  
}
