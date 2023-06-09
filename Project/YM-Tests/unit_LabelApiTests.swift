//
//  unit_LabelApiTests.swift
//  YM-API
//
//  Created by Developer on 15.10.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_LabelApiTests: XCTestCase {

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
    
    func testLabelAlbumsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        //Label studio Kitsune France, ID - 449298
        let labelId = "449298"
        client.getLabelAlbums(labelId: labelId, page: 0) { result in
            do {
                let labelInfo = try result.get()
                XCTAssertTrue(labelInfo.albums != nil, "Label albums is nil")
                XCTAssertFalse(labelInfo.albums?.count == 0, "Label albums is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Label albums info object: " + error.localizedDescription)
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

    func testLabelArtistsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        //Label studio Kitsune France, ID - 449298
        let labelId = "449298"
        client.getLabelArtists(labelId: labelId, page: 0) { result in
            do {
                let labelInfo = try result.get()
                XCTAssertTrue(labelInfo.artists != nil, "Label artists is nil")
                XCTAssertFalse(labelInfo.artists?.count == 0, "Label artists is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Label artists info object: " + error.localizedDescription)
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
