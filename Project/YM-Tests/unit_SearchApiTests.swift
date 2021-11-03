//
//  unit_SearchApiTests.swift
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

class unit_SearchApiTests: XCTestCase {

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
    
    func testNormalSearchSuggestionResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getSearchSugggestion(text: "ciao", completion: { result in
            do {
                let suggestion = try result.get()
                XCTAssertTrue(suggestion.suggestions.count > 0, "Possible text suggestions' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty search suggestion object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testIrrationalSearchSuggestionResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getSearchSugggestion(text: "bla bla bla abl abl abl", completion: { result in
            do {
                let suggestion = try result.get()
                XCTAssertNil(suggestion.best, "Best search suggestion isn't null")
                XCTAssertTrue(suggestion.suggestions.count == 0, "Possible text suggestions' array isn't empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty search suggestion object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 5) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testNormalSearchResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.search(text: "ciao", noCorrect: false, type: .all, page: 0, includeBestPlaylists: false) { result in
            do {
                let searchData = try result.get()
                XCTAssert(searchData.text.compare("ciao") == .orderedSame, "Search text from request (ciao) doesn't match with response data (" + searchData.text + ")")
            } catch {
                print(error)
                XCTAssert(false, "Empty search response object: " + error.localizedDescription)
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
    
    func testIrrationalSearchResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.search(text: "ciao", noCorrect: false, type: .all, page: -1, includeBestPlaylists: false) { result in            
            let search = try? result.get()
            XCTAssertNil(search, "Search response with negative page index isn't null")
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
    
    func testNextPageSearchResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.search(text: "ciao", noCorrect: false, type: .all, page: 0, includeBestPlaylists: false) { result in
            do {
                let search = try result.get()
                XCTAssert(search.text.compare("ciao") == .orderedSame, "Search text from request (ciao) doesn't match with response data (" + search.text + ")")
                search.nextPage(includeBestPlaylists: false) {result2 in
                    do {
                        let pageResult = try result2.get()
                        XCTAssert(pageResult.text.compare("ciao") == .orderedSame, "Search text from request (ciao) doesn't match with response data for another page (" + pageResult.text + ")")
                        let oldPage = search.page ?? -1
                        let newPage = pageResult.page ?? -1
                        XCTAssertTrue(oldPage != newPage, "Page identificators of search responses are same")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty search response object with next page: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty search response object: " + error.localizedDescription)
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
    
    
    func testPreviousPageSearchResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.search(text: "ciao", noCorrect: false, type: .all, page: 2, includeBestPlaylists: false) { result in
            do {
                let search = try result.get()
                XCTAssert(search.text.compare("ciao") == .orderedSame, "Search text from request (ciao) doesn't match with response data (" + search.text + ")")
                search.prevPage(includeBestPlaylists: false) {result2 in
                    do {
                        let pageResult = try result2.get()
                        XCTAssert(pageResult.text.compare("ciao") == .orderedSame, "Search text from request (ciao) doesn't match with response data for another page (" + pageResult.text + ")")
                        let oldPage = search.page ?? -1
                        let newPage = pageResult.page ?? -1
                        XCTAssertTrue(oldPage != newPage, "Page identificators of search responses are same")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty search response object with next page: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty search response object: " + error.localizedDescription)
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
    
    func testSearchHistoryResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getSearchHistory { result in
            do {
                let history = try result.get()
                XCTAssertTrue(history.count > 0, "Search history array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Search history array object: " + error.localizedDescription)
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
    
    func testFeedbackSearchHistoryResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let feedback = SearchFeedback(absBlockPosition: 3, absPosition: 3, blockPosition: 1, blockType: "album", entityId: "album:4440406", page: 0, position: 0, query: "beliver", searchRequestId: "music-stable-back-vla-22.vla.yp-c.yandex.net-1588698367499402-7678694071821572946-1588698367505")
        client.feedbackSearchHistory(feedback) { result in
            do {
                let status = try result.get()
                XCTAssertTrue(status, "False status search history feedback response")
            } catch {
                print(error)
                XCTAssert(false, "Empty feedback search history status: " + error.localizedDescription)
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
    
    func testClearSearchHistoryResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.clearSearchHistory { result in
            do {
                let status = try result.get()
                XCTAssertTrue(status, "False status search history clear response")
            } catch {
                print(error)
                XCTAssert(false, "Empty clear search history status: " + error.localizedDescription)
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
