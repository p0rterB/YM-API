//
//  unit_ArtistLikeApiTests.swift
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

class unit_ArtistLikeApiTests: XCTestCase {

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
    
    func testLikedArtistsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedArtists(likeTs: true) { result in
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

    func testLikeArtistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedArtists(likeTs: true) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like artists array is empty, unable to test 'Add' functionality")
                let artistLiked = likes[0].artist
                self.client.likeArtists(artistIds: [String(artistLiked?.id ?? 0)]) { result in
                    do {
                        let status = try result.get()
                        XCTAssertTrue(status, "Unable to like the artist")
                    } catch {
                        print(error)
                        XCTAssert(false, "Like operation error: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty like library object: " + error.localizedDescription)
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
    
    func testRemoveLikeArtistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedArtists(likeTs: true) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like artists array is empty, unable to test 'Remove' and 'Add' functionality")
                let artistLiked = likes[0].artist
                self.client.removeLikeArtists(artistIds: [String(artistLiked?.id ?? 0)]) { result in
                    do {
                        let removeSuccess = try result.get()
                        XCTAssert(removeSuccess, "Unable to remove like for the artist")
                        self.client.likeArtists(artistIds: [String(artistLiked?.id ?? 0)]) { result in
                            do {
                                let status = try result.get()
                                XCTAssertTrue(status, "Unable to like the artist")
                            } catch {
                                print(error)
                                XCTAssert(false, "Like operation error: " + error.localizedDescription)
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
