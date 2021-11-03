//
//  unit_ApiProviderTests.swift
//  YM-API
//
//  Created by Developer on 02.09.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_ApiProviderTests: XCTestCase {

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

    func testDataResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.sendRawDataRequest(basePath: "https://api.music.yandex.net/", payloadPath: "account/status", authHeaderValue: token, headers: [:], method: "GET", bodyData: nil, completion: { (result: Result<Data, YMError>) in
            let data = try? result.get()
            XCTAssertNotNil(data, "Response data is nil")
            XCTAssertTrue(data?.count != 0, "Response data is empty")
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
    
    func testJsonResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.sendRawDataRequest(basePath: "https://api.music.yandex.net/", payloadPath: "account/status", authHeaderValue: token, headers: [:], method: "GET", bodyData: nil, completion: { (result: Result<[String: Any], YMError>) in
            let json = try? result.get()
            XCTAssertNotNil(json, "Response json is nil")
            XCTAssertTrue(json?.count != 0, "Response json is empty")
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
    
    func testYmParsedPayloadResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.sendRawDataRequest(basePath: "https://api.music.yandex.net/", payloadPath: "account/status", authHeaderValue: token, headers: [:], method: "GET", bodyData: nil, completion: { (result: Result<YMResponse, YMError>) in
            let ymResponse = try? result.get()
            XCTAssertNotNil(ymResponse, "Prased response is nil")
            XCTAssertNotNil(ymResponse?.invocationInfo, "Response invocation info is nil")
            XCTAssertTrue(ymResponse?.result != nil && ymResponse?.error == nil, "Response payload data is nil")
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
    
    func testYmParsedErrorResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.sendRawDataRequest(basePath: "https://api.music.yandex.net/", payloadPath: "queues", authHeaderValue: token, headers: ["Content-Type": "application/json; charset=UTF-8"], method: "POST", bodyData: "{}".data(using: .utf8), completion: { (result: Result<YMResponse, YMError>) in
            let ymResponse = try? result.get()
            XCTAssertNotNil(ymResponse, "Prased response is nil")
            XCTAssertNotNil(ymResponse?.invocationInfo, "Response invocation info is nil")
            XCTAssertTrue(ymResponse?.error != nil && ymResponse?.result == nil, "Response error block is nil")
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
}

