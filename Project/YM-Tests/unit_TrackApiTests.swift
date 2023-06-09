//
//  unitTrackApiTests.swift
//  YM-macTests
//
//  Created by Developer on 20.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_TrackApiTests: XCTestCase {

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
    
    func testTrackSingleResponse() async {
        let trackId = "51965869:7956489"
        //let exp = self.expectation(description: "Request time-out expectation")
        _ = await withCheckedContinuation { continuation in
            client.getTracks(trackIds: [trackId], positions: false) { result in
                do {
                    let tracks = try result.get()
                    XCTAssertNotNil(tracks, "Track is nil")
                    XCTAssert(tracks.count > 0, "Tracks' array is empty")
                    XCTAssert(tracks[0].trackId.compare(trackId) == .orderedSame, "Incorrect parsing track object")
                } catch {
                    print(error)
                    XCTAssert(false, "Empty track object: " + error.localizedDescription)
                }
                continuation.resume()
            }
        }
    }
    
    func testSimilarTracksResponse() {
        let trackId = "51965869:7956489"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getSimilarTracks(trackId: trackId) { result in
            do {
                let tracks = try result.get()
                let stockTrack = tracks.track
                XCTAssertNotNil(stockTrack, "Track is nil")
                XCTAssert(tracks.similarTracks.count > 0, "Tracks' array is empty")
                XCTAssert(stockTrack?.trackId.compare(trackId) == .orderedSame, "Stock track in similar tracks response doesn't match to the expected")
            } catch {
                print(error)
                XCTAssert(false, "Empty tracks array: " + error.localizedDescription)
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
    
    func testTrackSuplementResponse() {
        let trackId = "33943347:4158732"
        let trackUID = "33943347"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTrackSupplement(trackId: trackId) { result in
            do {
                let supplement = try result.get()
                let supId = supplement.id
                XCTAssertTrue(supId.compare(trackUID) == .orderedSame, "Incorrect track supplement id")
            } catch {
                print(error)
                XCTAssert(false, "Empty track supplement info: " + error.localizedDescription)
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
    
    func testTracksArrayResponse() {
        let tracksId = ["51965869:7956489", "33943347:4158732"]
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTracks(trackIds: tracksId, positions: false) { result in
            do {
                let tracks = try result.get()
                XCTAssert(tracks.count > 0, "Tracks' array is empty")
                XCTAssert(tracks.count == tracksId.count, "Response doesn't contain all tracks")
                for i in 0...tracksId.count - 1 {
                    let trackId = tracksId[i]
                    let track = tracks[i]
                    XCTAssert(track.trackId.compare(trackId) == .orderedSame, "Incorrect parsing track object with trackId " + trackId)
                    //TODO add more model fields tests
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty track object: " + error.localizedDescription)
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
    
    
    func testGetTrackDownloadLink() {
        let trackId = "51965869:7956489"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTracks(trackIds: [trackId], positions: false) { result in
            do {
                let tracks = try result.get()
                XCTAssertNotNil(tracks, "Track is nil")
                XCTAssert(tracks.count > 0, "Tracks' array is empty")
                tracks[0].getDownloadInfo { result2 in
                    do {
                        let downloadInfos = try result2.get()
                        XCTAssertNotNil(downloadInfos, "Track download infos is nil")
                        XCTAssert(downloadInfos.count > 0, "Track download infos' array is empty")
                        
                        let info = downloadInfos[0]
                        info.getDirectLink { result in
                            do {
                                let link = try result.get()
                                XCTAssert(link.compare("") != .orderedSame, "Incorrect direct link format")
                            } catch {
                                print(error)
                                XCTAssert(false, "Empty track download link: " + error.localizedDescription)
                            }
                            exp.fulfill()
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty track download info object: " + error.localizedDescription)
                    }
                }
            }  catch {
                print(error)
                XCTAssert(false, "Empty track object: " + error.localizedDescription)
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
    
    func testGetTrackDownloadLinkV2() {
        let trackId = "51965869:7956489"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTracks(trackIds: [trackId], positions: false) { result in
            do {
                let tracks = try result.get()
                XCTAssertNotNil(tracks, "Track is nil")
                XCTAssert(tracks.count > 0, "Tracks' array is empty")
                tracks[0].getDownloadInfoV2(canUseStreaming: true) { result2 in
                    do {
                        let downloadInfos = try result2.get()
                        XCTAssertNotNil(downloadInfos, "Track download infos is nil")
                        XCTAssert(downloadInfos.count > 0, "Track download infos' array is empty")
                        
                        let info = downloadInfos[0]
                        info.getDirectLink { result in
                            do {
                                let link = try result.get()
                                XCTAssert(link.compare("") != .orderedSame, "Incorrect direct link format")
                            } catch {
                                print(error)
                                XCTAssert(false, "Empty track download link: " + error.localizedDescription)
                            }
                            exp.fulfill()
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty track download info object: " + error.localizedDescription)
                    }
                }
            }  catch {
                print(error)
                XCTAssert(false, "Empty track object: " + error.localizedDescription)
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
    
    func testGetTrackLyrics() {
        let trackId = "565378"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTracks(trackIds: [trackId], positions: false) { result in
            do {
                let tracks = try result.get()
                XCTAssertNotNil(tracks, "Track is nil")
                XCTAssert(tracks.count > 0, "Tracks' array is empty")
                tracks[0].getLyricsDownloadInfo(format: "LRC") { result2 in
                    do {
                        let downloadInfo = try result2.get()
                        XCTAssertNotNil(downloadInfo, "Track lyrics download info is nil")
                        exp.fulfill()
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty track lyrics info object: " + error.localizedDescription)
                    }
                }
            }  catch {
                print(error)
                XCTAssert(false, "Empty track object: " + error.localizedDescription)
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
