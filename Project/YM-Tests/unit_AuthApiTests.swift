//
//  unit_AuthApiTests.swift
//  YM-macTests
//
//  Created by Developer on 15.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_AuthApiTests: XCTestCase {

    var client: YMClient!
    var login: String {get {return TestConstants.login}}
    var pass: String {get {return TestConstants.pass}}
    var device: YMDevice {get {return TestConstants.device}}
    var apiLang: ApiLanguage {get {return TestConstants.apiLang}}
    
    override func setUp() {
        client = YMClient.initialize(device: device, lang: apiLang)
    }
    
    override func tearDown() {
        client = nil
    }

    func testAuthorizationResponse()
    {
        let exp = self.expectation(description: "Request time-out expectation")
        client.authByCredentials(login: login, pass: pass, captchaAnswer: nil, captchaKey: nil, captchaCallback: nil) { result in
            do {
                let dict = try result.get()
                let actualToken: String = dict[.access_token] ?? ""
                let expected = TestConstants.token
                XCTAssert(actualToken.compare(expected) == .orderedSame, "Actual response value of auth" + actualToken)
            } catch YMError.invalidResponseStatusCode(let errCode, let description) {
                let msg: String = "No actual response value of auth: code " + String(errCode) + " - " + description
                XCTAssert(false, msg)
                } catch {
                    print(error)
                    XCTAssert(false, "No actual response value of auth: " + error.localizedDescription)
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
    
    func testInitAuthResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.initializeAuthorization(login: login) { result in
            do {
                let trackId = try result.get()
                XCTAssertFalse(trackId.isEmpty, "Authorization track ID is empty")
            } catch {
                print(error)
                XCTAssert(false, "Nil authorization track ID: " + error.localizedDescription)
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
    
    func testAuthByPassResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.initializeAuthorization(login: login) { result in
            do {
                let trackId = try result.get()
                XCTAssertFalse(trackId.isEmpty, "Authorization track ID is empty")
                self.client.authorizeWithPassword(trackId: trackId, pass: self.pass, captchaAnswer: nil, captchaKey: nil, captchaCallback: nil) { result2 in
                    do {
                        let xRespObj = try result2.get()
                        XCTAssertTrue(xRespObj.status.compare("ok") == .orderedSame, xRespObj.errors?.joined(separator: ",") ?? "Invalid password")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty X Authenticate object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Nil authorization track ID: " + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 7) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testGenerateYMTokenResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.initializeAuthorization(login: login) { result in
            do {
                let trackId = try result.get()
                XCTAssertFalse(trackId.isEmpty, "Authorization track ID is empty")
                self.client.authorizeWithPassword(trackId: trackId, pass: self.pass, captchaAnswer: nil, captchaKey: nil, captchaCallback: nil) { result2 in
                    do {
                        let xRespObj = try result2.get()
                        XCTAssertTrue(xRespObj.status.compare("ok") == .orderedSame, xRespObj.errors?.joined(separator: ",") ?? "Invalid password")
                        XCTAssertTrue(xRespObj.x_token != nil, "X Token is nil")
                        self.client.generateYMTokenFromXToken(xToken: xRespObj.x_token!) { result3 in
                            do {
                                let dict = try result3.get()
                                let actualToken: String = dict[.access_token] ?? ""
                                XCTAssertFalse(actualToken.isEmpty, "Generated YM token is empty")
                            } catch YMError.invalidResponseStatusCode(let errCode, let description) {
                                let msg: String = "No actual response value of auth: code " + String(errCode) + " - " + description
                                XCTAssert(false, msg)
                            } catch {
                                print(error)
                                XCTAssert(false, "Nil YM token: " + error.localizedDescription)
                            }
                            exp.fulfill()
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty X Authenticate object: " + error.localizedDescription)
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Nil authorization track ID: " + error.localizedDescription)
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
