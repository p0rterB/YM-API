//
//  unit_AccountApiTests.swift
//  YM-macTests
//
//  Created by Developer on 16.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_AccountApiTests: XCTestCase {

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
    
    func testAccountStatusResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountStatus { result in
            do {
                let status = try result.get()
                let actualUid = status.account?.uid
                XCTAssertNotNil(actualUid, "Status account uid is nil")
                XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
            } catch {
                print(error)
                XCTAssert(false, "Empty account status object: " + error.localizedDescription)
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
    
    func testAccountAvaResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountStatus { result in
            do {
                let status = try result.get()
                let actualUid = status.account?.uid
                XCTAssertNotNil(actualUid, "Status account uid is nil")
                XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
                status.account?.downloadAvatar {
                    result2 in
                    do {
                        let avatarImg = try result2.get()
                        XCTAssertTrue(avatarImg.count > 0, "Account avatar is empty. Unable to test")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty account avatar object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty account status object: " + error.localizedDescription)
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
    
    func testUserInfoByUidResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let uid = 410060648
        client.getUserInfo(uid) { result in
            do {
                let info = try result.get()
                XCTAssert(uid == info.uid, "Actual and expected account UIDs are not same")
            } catch {
                print(error)
                XCTAssert(false, "Empty user info object: " + error.localizedDescription)
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
    
    func testUserInfoByNicknameResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let login = "gleb.liutsko"
        client.getUserInfo(login) { result in
            do {
                let info = try result.get()
                XCTAssert(login == info.login, "Actual and expected account UIDs are not same")
            } catch {
                print(error)
                XCTAssert(false, "Empty user info object: " + error.localizedDescription)
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
    
    func testAccountSettingsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountSettings { result in
            do {
                let settings = try result.get()
                let actualUid = settings.uid
                XCTAssertNotNil(actualUid, "Account settings uid is nil")
                XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
            } catch {
                print(error)
                XCTAssert(false, "Empty account settings object: " + error.localizedDescription)
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
    
    func testAccountSettingsEditResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountSettings { result in
            do {
                let settings = try result.get()
                var actualUid = settings.uid
                XCTAssertNotNil(actualUid, "Account settings uid is nil")
                XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
                self.client.setAccountSettings(values: [.theme: "black"]) { result2 in
                    do {
                        let editedSettings = try result2.get()
                        actualUid = editedSettings.uid
                        XCTAssertNotNil(actualUid, "Edited account settings uid is nil")
                        XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
                        XCTAssertTrue(editedSettings.theme.compare("black") == .orderedSame, "Edit parameters haven't changed")
                    } catch {
                        print(error)
                        XCTAssert(false, "Account settings edit fail: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty account settings object: " + error.localizedDescription)
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
    
    func testRotorAccountStatusReponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRotorAccountStatus { result in
            do {
                let status = try result.get()
                let actualUid = status.account?.uid
                XCTAssertNotNil(actualUid, "Status account uid is nil")
                XCTAssert(actualUid == Int(self.uid), "Actual and expected account UIDs are not same")
            } catch {
                print(error)
                XCTAssert(false, "Empty account status object: " + error.localizedDescription)
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
    
    func testPurchaseSuggestionsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountPurchaseSuggestions { result in
            do {
                let suggestions = try result.get()
                XCTAssertTrue(suggestions.inAppProducts.count > 0 || suggestions.nativeProducts.count > 0, "Purchase suggestions variants' array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty account purchase suggestions object: " + error.localizedDescription)
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
    
    func testAccountPermissionsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountPermissionAlerts { result in
            do {
                let alerts = try result.get()
                XCTAssertTrue(alerts.alerts.count >= 0, "Alerts count error (negative count)")
            } catch {
                print(error)
                XCTAssert(false, "Empty account permissions object: " + error.localizedDescription)
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
    
    func testSendPromoCodeResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.consumePromoCode("somePromo-Code") { result in
            do {
                let status = try result.get()
                XCTAssertTrue(!status.status.isEmpty && !status.statusDesc.isEmpty, "Consume promo code status data is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty promo code status object: " + error.localizedDescription)
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
    
    func testAccountExperimentsResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getAccountExperiments { result in
            do {
                let prefs = try result.get()
                XCTAssertTrue(prefs.count > 0, "Account experiments dictionary is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Account experiments object: " + error.localizedDescription)
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
