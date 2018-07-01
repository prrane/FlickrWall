//
//  ImageDownloadManager.swift
//  FlickrWall
//
//  Created by Prashant Rane on 01/07/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

class PhotoDownloadManager: NSObject {

  private var kPhotosDownloadContext = 1

  private let downloadQueue = AsyncQueue(named: "com.prrane.flickr.photo.download", maxConcurrentOperationCount: 5)

  private let dictionaryQueue = DispatchQueue(label: "com.prrane.flickr.photo.download.dictionary")

  private var photoIdToDownloadOperationsMap = [String: PhotoDownloadOperation]()

  // Used to start/stop downloading

  var okToProceed = false

  func cancelAllOperations(shouldResetCache: Bool = false) {
    downloadQueue.cancelAllOperations()
    okToProceed = false

    if shouldResetCache {
      PhotosCache.shared.invalidateCache()
    }
  }

  func downloadPhoto(with photoModel: Photo) {
    guard okToProceed else {
      print("Not ok to proceed photo download")
      return
    }

    var isDownloadForProvidedPhotoModelInProgress = false
    dictionaryQueue.sync {
      let filteredOperations = photoIdToDownloadOperationsMap.keys.filter { $0 == photoModel.id }
      isDownloadForProvidedPhotoModelInProgress = !filteredOperations.isEmpty
    }

    guard !isDownloadForProvidedPhotoModelInProgress else {
      print("The Photo \(photoModel.id) download is already in progress")
      return
    }

    guard let url = photoModel.downloadURL else {
      print("Could not generate url for model: \(photoModel) ")
      return
    }

    let downloadOperation = PhotoDownloadOperation(with: photoModel.id, photoURL: url)
    downloadOperation.addObserver(self, forKeyPath: #keyPath(PhotoDownloadOperation.state), options: .new, context: &kPhotosDownloadContext)
    downloadQueue.addOperation(downloadOperation)

    dictionaryQueue.sync {
      photoIdToDownloadOperationsMap[photoModel.id] = downloadOperation
    }
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard context == &kPhotosDownloadContext else {
      super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
      return
    }

    guard let downloaOperation = object as? PhotoDownloadOperation else {
      return
    }

    guard keyPath == #keyPath(PhotoDownloadOperation.state) else {
      return
    }

    guard let newValue = change?[NSKeyValueChangeKey.newKey] as? Int, newValue == AsyncOperation.State.finished.rawValue else {
      return
    }

    // Remove operation
    downloaOperation.removeObserver(self, forKeyPath: #keyPath(PhotoDownloadOperation.state))
    dictionaryQueue.sync {
      photoIdToDownloadOperationsMap.removeValue(forKey: downloaOperation.photoId)
      print("Pending Photo Downloads: \(photoIdToDownloadOperationsMap.keys.count)")
    }
  }

}
