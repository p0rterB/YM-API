//
//  unit_LandingApiTests.swift
//  YM-API
//
//  Created by Developer on 01.09.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_LandingApiTests: XCTestCase {

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
    
    func testLandingAllBlocksResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let blocks: [LandingBlock] = LandingBlock.allCases
        client.getLanding(blocks: blocks) { result in
            do {
                let landing = try result.get()
                XCTAssertTrue(landing.blocks.count > 0, "Actual blocks count doesn't match to expected")
            } catch {
                print(error)
                XCTAssert(false, "Empty chart object: " + error.localizedDescription)
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
    
    func testChartResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let option = "world"
        client.getChart(option: option) { result in
            do {
                let chart = try result.get()
                XCTAssertTrue(chart.type.compare("chart") == .orderedSame, "Response object isn't chart")
                XCTAssertTrue(chart.chart != nil, "Chart playlist data is nil")
            } catch {
                print(error)
                XCTAssert(false, "Empty chart object: " + error.localizedDescription)
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
    
    func testPodcastsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getPodcasts { result in
            do {
                let podcasts = try result.get()
                XCTAssertTrue(podcasts.type.compare("podcasts") == .orderedSame, "Response object isn't podcasts' list")
                XCTAssertTrue(podcasts.podcasts?.count != 0, "Podcasts array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty podcasts array object: " + error.localizedDescription)
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
    
    func testGenresResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getGenres { result in
            do {
                let genres = try result.get()
                XCTAssertTrue(genres.count > 0, "Genres array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Genres array object: " + error.localizedDescription)
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
