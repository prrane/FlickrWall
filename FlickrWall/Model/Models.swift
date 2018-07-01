//
//  Models.swift
//  FlickrWall
//
//  Created by Prashant Rane on 30/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import Foundation

struct Photo: Codable {
  let id: String
  let secret: String
  let server: String
  let farm: Int

  var downloadURL: URL? {
    //https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
    let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    return URL(string: url)
  }
}

struct SearchResults: Codable {
  let currentPage: Int
  let totalPages: Int
  let resultsPerPage: Int

  let photos: [Photo]

  enum CodingKeys: String, CodingKey {
    case currentPage = "page"
    case totalPages = "pages"
    case resultsPerPage = "perpage"
    case photos = "photo"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    currentPage = try container.decode(Int.self, forKey: .currentPage)
    totalPages = try container.decode(Int.self, forKey: .totalPages)
    resultsPerPage = try container.decode(Int.self, forKey: .resultsPerPage)
    photos = try container.decode([Photo].self, forKey: .photos)
  }

}

struct APIResponse: Codable {
  let results: SearchResults?
  let status: String
  let errorCode: Int?
  let errorMessage: String?

  enum CodingKeys: String, CodingKey {
    case results = "photos"
    case status = "stat"
    case errorCode = "code"
    case errorMessage = "message"
  }

}
