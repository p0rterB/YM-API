//
//  unit_TrackLikeApiTests.swift
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

class unit_TrackLikeApiTests: XCTestCase {

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
    
    func testLikedTracksResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedTracks(modifiedRevision: 0) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertNotNil(likes.tracks, "Track likes is nil")
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
    
    func testTrackAddLikeResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedTracks(modifiedRevision: nil) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertNotNil(likes.tracks, "Track likes is nil")
                let tracks = likes.tracks ?? []
                if tracks.count > 0, let g_id = tracks[0].id {
                    self.client.likeTracks(trackIds: [g_id]) { result in
                        do {
                            let revision = try result.get()
                            XCTAssert(revision > 0, "Like library revision number is 0")
                        } catch {
                            print(error)
                            XCTAssert(false, "Empty like library revision number: " + error.localizedDescription)
                        }
                        exp.fulfill()
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
    
    func testTrackRemoveLikeResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLikedTracks(modifiedRevision: nil) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Like library is nil")
                XCTAssertNotNil(likes.tracks, "Track likes is nil")
                let tracks = likes.tracks ?? []
                if tracks.count > 0, let g_id = tracks[0].id {
                    self.client.removeLikeTracks(trackIds: [g_id]) { result2 in
                        do {
                            let revision = try result2.get()
                            XCTAssert(revision > 0, "Like library revision number is 0")
                            self.client.getLikedTracks(modifiedRevision: nil) { result3 in
                                do {
                                    let editedLikes = try result3.get()
                                    XCTAssertNotNil(likes, "Edited like library after removing like is nil")
                                    XCTAssertNotNil(likes.tracks, "Edited track likes after removing like is nil")
                                    let editedTracks = editedLikes.tracks ?? []
                                    if editedTracks.count > 0, let g_editedId = editedTracks[0].id {
                                        if (g_editedId.compare(g_id) == .orderedSame) {
                                            XCTAssert(false, "Like didn't removed")
                                        }
                                    }
                                    self.client.likeTracks(trackIds: [g_id]) { result in
                                        do {
                                            let revision = try result.get()
                                            XCTAssert(revision > 0, "Like library revision number is 0")
                                        } catch {
                                            print(error)
                                            XCTAssert(false, "Empty like library revision number: " + error.localizedDescription)
                                        }
                                        exp.fulfill()
                                    }
                                } catch {
                                    print(error)
                                    XCTAssert(false, "Empty likes library object: " + error.localizedDescription)
                                }
                            }
                        } catch {
                            print(error)
                            XCTAssert(false, "Empty like library revision number: " + error.localizedDescription)
                        }
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
    
    func testDislikedTracksResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getDislikedTracks(modifiedRevision: nil) { result in
            do {
                let dislikes = try result.get()
                XCTAssertNotNil(dislikes, "Dislike library is nil")
                XCTAssertNotNil(dislikes.tracks, "Track dislikes is nil")
            } catch {
                print(error)
                XCTAssert(false, "Empty Dislike library object: " + error.localizedDescription)
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
    
    func testTrackAddDislikeResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getDislikedTracks(modifiedRevision: nil) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Dislike library is nil")
                XCTAssertNotNil(likes.tracks, "Track likes is nil")
                let tracks = likes.tracks ?? []
                if tracks.count > 0, let g_id = tracks[0].id {
                    self.client.dislikeTracks(trackIds: [g_id]) { result in
                        do {
                            let revision = try result.get()
                            XCTAssert(revision > 0, "Dislike library revision number is 0")
                        } catch {
                            print(error)
                            XCTAssert(false, "Empty Dislike library revision number: " + error.localizedDescription)
                        }
                        exp.fulfill()
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty dislike library object: " + error.localizedDescription)
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
    
    func testTrackRemoveDislikeResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getDislikedTracks(modifiedRevision: nil) { result in
            do {
                let likes = try result.get()
                XCTAssertNotNil(likes, "Dislike library is nil")
                XCTAssertNotNil(likes.tracks, "Track dislikes is nil")
                let tracks = likes.tracks ?? []
                if tracks.count > 0, let g_id = tracks[0].id {
                    self.client.removeDislikeTracks(trackIds: [g_id]) { result2 in
                        do {
                            let revision = try result2.get()
                            XCTAssert(revision > 0, "Dislike library revision number is 0")
                            self.client.getDislikedTracks(modifiedRevision: nil) { result3 in
                                do {
                                    let editedLikes = try result3.get()
                                    XCTAssertNotNil(likes, "Edited dislike library after removing dislike is nil")
                                    XCTAssertNotNil(likes.tracks, "Edited track dislikes after removing dislike is nil")
                                    let editedTracks = editedLikes.tracks ?? []
                                    if editedTracks.count > 0, let g_editedId = editedTracks[0].id {
                                        if (g_editedId.compare(g_id) == .orderedSame) {
                                            XCTAssert(false, "Dislike didn't removed")
                                        }
                                    }
                                    self.client.dislikeTracks(trackIds: [g_id]) { result in
                                        do {
                                            let revision = try result.get()
                                            XCTAssert(revision > 0, "Dislike library revision number is 0")
                                        } catch {
                                            print(error)
                                            XCTAssert(false, "Empty dislike library revision number: " + error.localizedDescription)
                                        }
                                        exp.fulfill()
                                    }
                                } catch {
                                    print(error)
                                    XCTAssert(false, "Empty dislike library object: " + error.localizedDescription)
                                }
                            }
                        } catch {
                            print(error)
                            XCTAssert(false, "Empty dislike library revision number: " + error.localizedDescription)
                        }
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty dislike library object: " + error.localizedDescription)
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
