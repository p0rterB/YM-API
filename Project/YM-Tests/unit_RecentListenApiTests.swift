//
//  unit_RecentListenApiTests.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_RecentListenApiTests: XCTestCase {

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
    
    func testRecentListenHistoryResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRecentListenHistory(tracksCount: 2, contextTypes: [.album, .artist]) { result in
            do {
                let listenHistory = try result.get()
                XCTAssertTrue(listenHistory.contexts.count > 0, "Listen history empty array")
            } catch {
                print(error)
                XCTAssert(false, "Empty Listen history object: " + error.localizedDescription)
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
