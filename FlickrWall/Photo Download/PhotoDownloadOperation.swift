//
//  PhotoDownloadOperation.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class PhotoDownloadOperation: AsyncOperation {

  let photoURL: URL
  let photoId: String

  init(with photoId: String, photoURL: URL)  {
    self.photoId = photoId
    self.photoURL = photoURL
  }

  override func start() {
    print("Download: Operation Started for \(photoId)")

    guard !self.isCancelled else {
      print("Download: Marked as finished because it is cancelled for \(photoId)")
      self.state = .finished
      return
    }

    state = .executing
    execute()
  }

  private func execute() {

    URLSession.shared.dataTask(with: photoURL) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
      self?.state = .finished
      print("Download: Operation finished for \(String(describing: self?.photoId))")

      guard error == nil else {
        return
      }

      guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
        return
      }

      guard statusCode >= 200 && statusCode < 300 else {
        return
      }

      guard let strongSelf = self else {
        return
      }

      PhotosCache.shared.add(data: data, for: strongSelf.photoId)

      }.resume()

  }

}
