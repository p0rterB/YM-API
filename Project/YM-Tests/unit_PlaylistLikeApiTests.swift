//
//  unit_PlaylistLikeApiTests.swift
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

class unit_PlaylistLikeApiTests: XCTestCase {

    var client: YMClient!
    var device: YMDevice {get {return TestConstants.device}}
    var apiLang: ApiLanguage {get {return TestConstants.apiLang}}
    var token: String {get {return TestConstants.token}}
    var xToken: String {get {return TestConstants.xToken}}
    var uid: Int {get {return TestConstants.uid}}
    
    override func setUp() {
        client = YMClient.initialize(device: device, lang: apiLang, uid: uid, token: token, xToken: xToken)
    }
    
    override func tearDown() {
        client = nil
    }
    
    func testLikedPlaylistsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedPlaylists() { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Liked playlists array is nil")
                XCTAssert(likes.count > 0, "Playlist' array is empty.")
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

    func testLikePlaylistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedPlaylists { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like playlists array is empty, unable to test 'Add' functionality")
                let playlistLiked = likes[0].playlist
                let idString = playlistLiked?.playlistId ?? "0"
                self.client.likePlaylists(playlistIds: [idString]) { result in
                    do {
                        let status = try result.get()
                        XCTAssertTrue(status, "Unable to like the playlist")
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
    
    func testRemoveLikePlaylistResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedPlaylists { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertTrue(likes.count > 0, "Like playlists array is empty, unable to test 'Add' functionality")
                let playlistLiked = likes[0].playlist
                let idString = playlistLiked?.playlistId ?? "0"
                self.client.removeLikePlaylists(playlistIds: [idString]) { result in
                    do {
                        let removeSuccess = try result.get()
                        XCTAssert(removeSuccess, "Unable to remove like for the playlist")
                        self.client.likePlaylists(playlistIds: [idString]) { result in
                            do {
                                let status = try result.get()
                                XCTAssertTrue(status, "Unable to like the playlist")
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
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
