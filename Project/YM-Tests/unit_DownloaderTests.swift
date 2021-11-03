//
//  unit_DownloaderTests.swift
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

class unit_DownloaderTests: XCTestCase {

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
    
    func testTrackDownload() {
        let trackId = "51965869:7956489"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTracks(trackIds: [trackId], positions: false) { result in
            do {
                let tracks = try result.get()
                XCTAssertNotNil(tracks, "Track is nil")
                XCTAssert(tracks.count > 0, "Tracks' array is empty")
                tracks[0].downloadTrack { result2 in
                    do {
                        let data = try result2.get()
                        XCTAssert(data.count != 0, "Received 0 bytes")
                    } catch {
                        print(error)
                        XCTAssert(false, "No audio data of track: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            }  catch {
                print(error)
                XCTAssert(false, "Empty track object: " + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 60) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
