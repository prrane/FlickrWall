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

  @objc open dynamic var didCached: String = "" {
    willSet {
      willChangeValue(forKey: "didCached")
    }
    didSet {
      didChangeValue(forKey: "didCached")
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
    didCached = id
  }

  func photo(for id: String) -> UIImage? {
    guard let cachedImage = cache[id] else {
      return nil
    }

    return cachedImage
  }
  
}
