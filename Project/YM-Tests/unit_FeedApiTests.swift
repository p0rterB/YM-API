//
//  unit_FeedApiTests.swift
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

class unit_FeedApiTests: XCTestCase {

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
    
    func testFeedResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getFeed { result in
            do {
                let feed = try result.get()
                XCTAssertNotNil(feed.generatedPlaylists, "Feed generated playlists is null")
                XCTAssert(feed.generatedPlaylists.count > 0, "Feed generated playlists is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty feed object: " + error.localizedDescription)
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
