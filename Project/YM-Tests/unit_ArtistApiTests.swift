//
//  unit_ArtistApiTests.swift
//  YM-macTests
//
//  Created by Developer on 26.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_ArtistApiTests: XCTestCase {
    
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

    func testArtistSingleResponse() {
        let artistId = 4699882
        let exp = self.expectation(description: "Request time-out expectation")
        client.getArtists(artistIds: [String(artistId)]) { result in
            do {
                let artists = try result.get()
                XCTAssertNotNil(artists, "Artist is nil")
                XCTAssert(artists.count > 0, "Artists' array is empty")
                XCTAssert(artists[0].id == artistId, "Incorrect parsing artist object")
            } catch {
                print(error)
                XCTAssert(false, "Empty artist object: " + error.localizedDescription)
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
    
    func testArtistImgResponse() {
        let artistId = 4699882
        let exp = self.expectation(description: "Request time-out expectation")
        client.getArtists(artistIds: [String(artistId)]) { result in
            do {
                let artists = try result.get()
                XCTAssertNotNil(artists, "Artist is nil")
                XCTAssert(artists.count > 0, "Artists' array is empty")
                XCTAssert(artists[0].id == artistId, "Incorrect parsing artist object")
                artists[0].cover?.downloadImg {
                    result2 in
                    do {
                        let data = try result2.get()
                        XCTAssertTrue(data.count > 0, "Empty artist image data")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty artist cover object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty artist object: " + error.localizedDescription)
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
    
    func testArtistShortInfoResponse() {
        let artistId = 4699882
        let exp = self.expectation(description: "Request time-out expectation")
        client.getArtistShortInfo(artistId: String(artistId)) { result in
            do {
                let artist = try result.get()
                XCTAssert(artist.artist?.id == artistId, "Incorrect parsing artist object")
            } catch {
                print(error)
                XCTAssert(false, "Empty artist object: " + error.localizedDescription)
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
    
    func testArtistTracksResponse() {
        let artistId = 4699882
        let exp = self.expectation(description: "Request time-out expectation")
        client.getArtistTracks(artistId: String(artistId)) { result in
            do {
                let tracks = try result.get()
                XCTAssertTrue(tracks.pager != nil, "Artist tracks pager is nil")
                if let g_pager = tracks.pager {
                    XCTAssertTrue(g_pager.page == 0, "Actual page index doesn't match with actual")
                    XCTAssertTrue(20 == g_pager.perPage || (g_pager.perPage == g_pager.total && g_pager.perPage <= 20), "Page size is incorrectly parsed")
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty artist tracks object: " + error.localizedDescription)
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
    
    func testArtistDirectAlbumsResponse() {
        let artistId = 4699882
        let exp = self.expectation(description: "Request time-out expectation")
        client.getArtistDirectAlbums(artistId: String(artistId), sortBy: .year) { result in
            do {
                let albums = try result.get()
                XCTAssertTrue(albums.pager != nil, "Artist direct albums pager is nil")
                if let g_pager = albums.pager {
                    XCTAssertTrue(g_pager.page == 0, "Actual page index doesn't match with actual")
                    XCTAssertTrue(20 == g_pager.perPage || (g_pager.perPage == g_pager.total && g_pager.perPage <= 20), "Page size is incorrectly parsed")
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty artist direct albums object: " + error.localizedDescription)
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
