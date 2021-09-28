//
//  unit_AlbumApiTests.swift
//  YM-macTests
//
//  Created by Developer on 21.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_AlbumApiTests: XCTestCase {

    var client: YMClient!
    var device: YMDevice {get {return TestConstants.device}}
    var apiLang: ApiLanguage {get {return TestConstants.apiLang}}
    var token: String {get {return TestConstants.token}}
    var uid: Int {get {return TestConstants.uid}}

    override func setUp() {
        client = YMClient.initialize(device: device, lang: apiLang, uid: uid, token: token)
    }
    
    override func tearDown() {
        client = nil
    }

    func testAlbumSingleResponse() {
        let albumId = 4158732
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAlbums(albumIds: [String(albumId)]) { result in
            do {
                let albums = try result.get()
                XCTAssertNotNil(albums, "Album is nil")
                XCTAssert(albums.count > 0, "Albums' array is empty")
                XCTAssert(albums[0].id == albumId, "Incorrect parsing album object")
                XCTAssert(albums[0].error == nil || albums[0].error == "", "Album not found")
            } catch {
                print(error)
                XCTAssert(false, "Empty album object: " + error.localizedDescription)
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
    
    func testAlbumCoverResponse() {
        let albumId = 4158732
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAlbums(albumIds: [String(albumId)]) { result in
            do {
                let albums = try result.get()
                XCTAssertNotNil(albums, "Album is nil")
                XCTAssert(albums.count > 0, "Albums' array is empty")
                XCTAssert(albums[0].id == albumId, "Incorrect parsing album object")
                XCTAssert(albums[0].error == nil || albums[0].error == "", "Album not found")
                albums[0].downloadCoverImg {
                    result2 in
                    do {
                        let cover = try result2.get()
                        XCTAssertTrue(cover.count > 0, "Album cover is empty. Unable to test")
                    }  catch {
                        print(error)
                        XCTAssert(false, "Empty album cover data: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty album object: " + error.localizedDescription)
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
    
    func testAlbumOgImgResponse() {
        let albumId = 4158732
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAlbums(albumIds: [String(albumId)]) { result in
            do {
                let albums = try result.get()
                XCTAssertNotNil(albums, "Album is nil")
                XCTAssert(albums.count > 0, "Albums' array is empty")
                XCTAssert(albums[0].id == albumId, "Incorrect parsing album object")
                XCTAssert(albums[0].error == nil || albums[0].error == "", "Album not found")
                albums[0].downloadOgImage {
                    result2 in
                    do {
                        let og = try result2.get()
                        XCTAssertTrue(og.count > 0, "Album cover is empty. Unable to test")
                    }  catch {
                        print(error)
                        XCTAssert(false, "Empty album cover data: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty album object: " + error.localizedDescription)
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

    func testNewAlbumsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getNewAlbums{ result in
            do {
                let albums = try result.get()
                XCTAssertTrue(albums.type.compare("new-releases") == .orderedSame, "Response doesn't contain new albums")
                XCTAssertTrue(albums.newReleases?.count != 0, "New albums' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty new albums array object: " + error.localizedDescription)
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
    
    func testAlbumWitthTracksResponse() {
        let albumId = 4158732
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAlbumWithTracksData(albumId: String(albumId)) { result in
            do {
                let album = try result.get()
                XCTAssert(album.id == albumId, "Incorrect parsing album object")
                XCTAssertTrue(album.volumes?.count != 0, "No volumes info with tracks in the album")
                XCTAssertTrue(album.volumes?[0].count != 0, "No tracks info in the album inside the volume")
            } catch {
                print(error)
                XCTAssert(false, "Empty album object: " + error.localizedDescription)
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
}
