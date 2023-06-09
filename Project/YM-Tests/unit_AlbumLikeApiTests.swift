//
//  unit_AlbumLikeApiTests.swift
//  YM-macTests
//
//  Created by Developer on 25.08.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_AlbumLikeApiTests: XCTestCase {

    var client: YMClient!
    var device: YMDevice {get {return TestConstants.device}}
    var apiLang: ApiLanguage {get {return TestConstants.apiLang}}
    var token: String {get {return TestCredentials.token}}
    var xToken: String {get {return TestCredentials.xToken}}
    var uid: Int {get {return TestCredentials.uid}}
    
    override func setUp() {
        client = YMClient.initialize(device: device, lang: apiLang, uid: uid, token: token, xToken: xToken)
    }
    
    override func tearDown() {
        client = nil
    }
    
    func testLikedAlbumsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedAlbums(rich: false) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
            } catch {
                print(error)
                XCTAssert(false, "Empty likes library object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testLikeAlbumResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedAlbums(rich: false) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like albums array is empty, unable to test 'Add' functionality")
                let albumLiked = likes[0].albumId ?? likes[0].id
                self.client.likeAlbums(albumIds: [albumLiked ?? "0"]) { result in
                    do {
                        let status = try result.get()
                        XCTAssertTrue(status, "Unable to like the album")
                    } catch {
                        print(error)
                        XCTAssert(false, "Like operation error : " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty likes library object: " + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testRemoveLikeAlbumResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedAlbums(rich: false) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like albums array is empty, unable to test 'Remove' and 'Add' functionality")
                let albumLiked = likes[0].albumId ?? likes[0].id
                self.client.removeLikeAlbums(albumIds: [albumLiked ?? "0"]) { result in
                    do {
                        let removeSuccess = try result.get()
                        XCTAssert(removeSuccess, "Unable to remove like for the album")
                        self.client.likeAlbums(albumIds: [albumLiked ?? "0"]) { result in
                            do {
                                let status = try result.get()
                                XCTAssertTrue(status, "Unable to like the album")
                            } catch {
                                print(error)
                                XCTAssert(false, "Like operation error : " + error.localizedDescription)
                            }
                            exp.fulfill()
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Remove like operation error: " + error.localizedDescription)
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty likes library object: " + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
