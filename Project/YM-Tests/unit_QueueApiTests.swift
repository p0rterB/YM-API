//
//  unit_QueueApiTests.swift
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

class unit_QueueApiTests: XCTestCase {

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
    
    func testQueuesListResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getQueuesList(device: device) { result in
            do {
                let list = try result.get()
                if (list.queues.count > 0) {
                    XCTAssertTrue(!list.queues[0].id.isEmpty, "Queue ID is empty")
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty queues list object: " + error.localizedDescription)
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
    
    func testQueueDataResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getQueuesList(device: device) { result in
            do {
                let list = try result.get()
                XCTAssertTrue(list.queues.count > 0, "Queues list is empty. Unable to test queue fetching data")
                let queueId = list.queues[0].id
                self.client.getQueueData(queueId: queueId) { result2 in
                    do {
                        let queue = try result2.get()
                        XCTAssertTrue(queue.id?.compare(queueId) == .orderedSame, "Response queue ID mismatch")
                        XCTAssertNotNil(queue.context, "Queue context is nil")
                        XCTAssertTrue(queue.tracks.count > 0, "Queue tracks' array is empty")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty queue object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty queues list object: " + error.localizedDescription)
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
    
    func testCreateQueueResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        let context = QueueContext(type: "radio", id: "user:onyourwave", description: "NonExistPlaylist")
        let queue = Queue.initializeNewQueue(context: context, tracks: [])
        client.createQueue(queue: queue, device: device) { result in
            do {
                let newQueue = try result.get()
                XCTAssertNotNil(newQueue.id, "Queue ID is nil")
                XCTAssertTrue(newQueue.currIndex == 0, "Queue index not equal to 0")
            } catch {
                print(error)
                XCTAssert(false, "Empty queues list object: " + error.localizedDescription)
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
    
    func testQueueIndexSetResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getQueuesList(device: device) { result in
            do {
                let list = try result.get()
                XCTAssertTrue(list.queues.count > 0, "Queues list is empty. Unable to test queue fetching data")
                let queueId = list.queues[0].id
                self.client.getQueueData(queueId: queueId) { result2 in
                    do {
                        let queue = try result2.get()
                        XCTAssertTrue(queue.id?.compare(queueId) == .orderedSame, "Response queue ID mismatch")
                        XCTAssertNotNil(queue.context, "Queue context is nil")
                        XCTAssertTrue(queue.tracks.count > 0, "Queue tracks' array is empty")
                        let currIndex = queue.currIndex
                        self.client.setQueueIndex(queueId: queueId, newIndex: currIndex + 1, device: self.device) {
                            result3 in
                            do {
                                let status = try result3.get()
                                XCTAssertTrue(status, "Queue updating index fail")
                            } catch {
                                print(error)
                                XCTAssert(false, "Queue updating index fail: " + error.localizedDescription)
                            }
                            exp.fulfill()
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty queue object: " + error.localizedDescription)
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty queues list object: " + error.localizedDescription)
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
}
