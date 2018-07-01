//
//  FlickrWallTests.swift
//  FlickrWallTests
//
//  Created by Prashant Rane on 29/06/18.
//  Copyright © 2018 Prashant Rane. All rights reserved.
//

import XCTest
@testable import FlickrWall

class FlickrWallTests: XCTestCase {

  private var validResponseJSON: String =
  {
    return """
      {
      "photos": {
      "page": 1,
      "pages": 5164,
      "perpage": 5,
      "total": "123467",
      "photo": [{
      "id": "42147473625",
      "owner": "100472572@N08",
      "secret": "0c6e0a2157",
      "server": "839",
      "farm": 1,
      "title": "Foo Fighters",
      "ispublic": 1,
      "isfriend": 0,
      "isfamily": 0
      }, {
      "id": "41217094340",
      "owner": "157023062@N05",
      "secret": "ce3b36d316",
      "server": "1764",
      "farm": 2,
      "title": "830- 5455",
      "ispublic": 1,
      "isfriend": 0,
      "isfamily": 0
      }]
      },
      "stat": "ok"
      }
    """
  }()

  private var errorResponseJSON: String = {
    return """
    {
    "stat": "fail",
    "code": 112,
    "message": "Something went wrong"
    }
    """
  }()

  private func data(for json: String) -> Data? {
    return json.data(using: .utf8)
  }

  func testValidJSONResponse() {
    guard let jsonData = data(for: validResponseJSON) else {
      XCTFail("Could not generate JSON data from trest JSON string")
      return
    }

    do {
      let reponse = try JSONDecoder().decode(APIResponse.self, from: jsonData)
      guard reponse.errorCode == nil else {
        XCTFail("No error code expected here")
        return
      }

      guard let photos = reponse.results?.photos else {
        XCTFail("No photos available in API response")
        return
      }

      XCTAssert(reponse.status == "ok", "The valid json should always have `ok` status, actual: \(reponse.status)")
      XCTAssert(photos.count == 2, "There should be two photos in the valid json response, actual: \(photos.count)")

      let photo = photos.first!
      XCTAssert(!photo.id.isEmpty, "Photo Id can not be empty")
      XCTAssert(!photo.secret.isEmpty, "Photo Secrete can not be empty")
      XCTAssert(!photo.server.isEmpty, "Photo Id Server not be empty")
    }
    catch let error {
      XCTFail("\n\(error)\n")
    }
  }

  func testErrorJSONResponse() {
    guard let jsonData = data(for: errorResponseJSON) else {
      XCTFail("Could not generate JSON data from trest JSON string")
      return
    }

    do {
      let reponse = try JSONDecoder().decode(APIResponse.self, from: jsonData)
      guard reponse.errorCode == nil else {

        return
      }

      XCTAssert(reponse.errorCode == 112, "An error code 112 is expected here, actual: \(String(describing: reponse.errorCode))")

      XCTAssert(reponse.status == "fail", "Unexpected response status, expected `fail`, actual: \(reponse.status)")
      XCTAssert(reponse.errorMessage?.isEmpty ?? false, "Error message should not be nil")
      XCTAssert(reponse.results == nil, "There should be no photos available in case of error, actual count: \(String(describing: reponse.results))")
    }
    catch let error {
      XCTFail("\n==>\n\(error)\n")
    }
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }
    
}
