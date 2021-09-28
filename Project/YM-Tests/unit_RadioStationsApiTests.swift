//
//  unit_RadioStationsApiTests.swift
//  YM-API
//
//  Created by Developer on 26.08.2021.
//

import Foundation

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_RadioStationsApiTests: XCTestCase {
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
    
    func testRadioDashboardResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationsDashboard() {
            result in
            do {
                let dashboard = try result.get()
                XCTAssertNotNil(dashboard, "Radio stations dashboard is nil")
                XCTAssertTrue(dashboard.stations.count > 0, "Radio stations list is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations dashboard object: " + error.localizedDescription)
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
    
    func testRadioStationsListResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationsList() {
            result in
            do {
                let stations = try result.get()
                XCTAssertTrue(stations.count > 0, "Radio stations list is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioStationInfoResponse() {
        let stationId = "user:onyourwave"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationInfo(stationId: stationId) {
            result in
            do {
                let stations = try result.get()
                XCTAssertTrue(stations.count > 0, "Radio stations list is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioStationStartEventResponse() {
        
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationsDashboard() {
            result in
            do {
                let dashboard = try result.get()
                XCTAssertNotNil(dashboard, "Radio stations dashboard is nil")
                XCTAssertTrue(dashboard.stations.count > 0, "Radio stations list is empty")
                let stationId = dashboard.stations[0].station?.radioId ?? ""
                var from = "radio-mobile"
                if let g_forFrom = dashboard.stations[0].station?.idForFrom {
                    from += "-" + g_forFrom
                }
                self.client.sendRadioStationStartListening(stationId: stationId, timestamp8601: DateUtil.isoFormat(), fromInfo: from) { result in
                    do {
                        let success = try result.get()
                        XCTAssertTrue(success, "Radio station start listening event send fail")
                    } catch {
                        print(error)
                        XCTAssert(false, "Radio station start listening event send fail: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations dashboard object: " + error.localizedDescription)
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
    
    func testRadioStationTracksResponse() {
        let stationId = "user:onyourwave"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: nil) {
            result in
            do {
                let tracks = try result.get()
                XCTAssertTrue(tracks.sequence.count > 0, "Radio stations tracks list is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioTrackStartEventResponse() {
        let stationId = "user:onyourwave"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: nil) {
            result in
            do {
                let tracks = try result.get()
                XCTAssertTrue(tracks.sequence.count > 0, "Radio station tracks list is empty")
                let batchId = tracks.batchId
                let trackId = tracks.sequence[0].track?.trackId ?? "-1"
                self.client.sendRadioTrackStartListening(stationId: stationId, timestamp8601: DateUtil.isoFormat(), tracksBatchId: batchId, trackId: trackId) { result2 in
                    do {
                        let status = try result2.get()
                        XCTAssertTrue(status, "Radio station track start event send fail")
                    } catch {
                        print(error)
                        XCTAssert(false, "Radio station start track event send fail: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioTrackFinishEventResponse() {
        let stationId = "user:onyourwave"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: nil) {
            result in
            do {
                let tracks = try result.get()
                XCTAssertTrue(tracks.sequence.count > 0, "Radio station tracks list is empty")
                let batchId = tracks.batchId
                let trackId = tracks.sequence[0].track?.trackId ?? "-1"
                self.client.sendRadioTrackFinished(stationId: stationId, timestamp8601: DateUtil.isoFormat(), tracksBatchId: batchId, trackId: trackId, playedDurationInS: 10.45) { result2 in
                    do {
                        let status = try result2.get()
                        XCTAssertTrue(status, "Radio station track finish event send fail")
                    } catch {
                        print(error)
                        XCTAssert(false, "Radio station start track finish event send fail: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioTrackSkipEventResponse() {
        let stationId = "user:onyourwave"
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: nil) {
            result in
            do {
                let tracks = try result.get()
                XCTAssertTrue(tracks.sequence.count > 0, "Radio station tracks list is empty")
                let trackId = tracks.sequence[0].track?.trackId ?? "-1"
                self.client.sendRadioTrackSkip(stationId: stationId, timestamp8601: DateUtil.isoFormat(), trackId: trackId, playedSeconds: 10.45) { result2 in
                    do {
                        let status = try result2.get()
                        XCTAssertTrue(status, "Radio station track skip event send fail")
                    } catch {
                        print(error)
                        XCTAssert(false, "Radio station start track skip event send fail: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
    
    func testRadioBatchIterationResponse() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getRadioStationsDashboard() {
            result in
            do {
                let dashboard = try result.get()
                XCTAssertNotNil(dashboard, "Radio stations dashboard is nil")
                XCTAssertTrue(dashboard.stations.count > 0, "Radio stations list is empty. Unable to continue test")
                let station = dashboard.stations[0].station
                let stationId = station?.radioId ?? ""
                var from = "radio-mobile"
                if let g_forFrom = dashboard.stations[0].station?.idForFrom {
                    from += "-" + g_forFrom
                }
                self.client.sendRadioStationStartListening(stationId: stationId, timestamp8601: DateUtil.isoFormat(), fromInfo: from) { result in
                    do {
                        let success = try result.get()
                        XCTAssertTrue(success, "Radio station start listening event send fail")
                        
                        self.client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: nil) { result2 in
                            do {
                                let tracks = try result2.get()
                                XCTAssertTrue(tracks.sequence.count > 0, "Radio stations tracks list is empty")
                                let batchId = tracks.batchId
                                let trackId = tracks.sequence[0].track?.trackId ?? "-1"
                                
                                self.client.sendRadioTrackStartListening(stationId: stationId, timestamp8601: DateUtil.isoFormat(), tracksBatchId: batchId, trackId: trackId) { result3 in
                                    do {
                                        let status = try result3.get()
                                        XCTAssertTrue(status, "Radio station track start event send fail")
                                        
                                        self.client.sendRadioTrackSkip(stationId: stationId, timestamp8601: DateUtil.isoFormat(), trackId: trackId, playedSeconds: 10.45) { result4 in
                                            do {
                                                let status = try result4.get()
                                                XCTAssertTrue(status, "Radio station track skip event send fail")
                                                let secondTrackId = tracks.sequence[1].track?.trackId ?? "-1"
                                                
                                                self.client.sendRadioTrackSkip(stationId: stationId, timestamp8601: DateUtil.isoFormat(), trackId: secondTrackId, playedSeconds: 0.5) { result5 in
                                                    do {
                                                        let status = try result5.get()
                                                        XCTAssertTrue(status, "Radio station track skip event send fail")
                                                        
                                                        self.client.getRadioStationTracksBatch(stationId: stationId, lastTrackId: secondTrackId) { result6 in
                                                            do {
                                                                let newTracks = try result6.get()
                                                                XCTAssertTrue(tracks.sequence.count > 0, "Radio stations new tracks list is empty")
                                                                let newBatchId = newTracks.batchId
                                                                XCTAssertTrue(newBatchId.compare(batchId) != .orderedSame, "Tracks batches are same")
                                                                let firstNewTrackId = newTracks.sequence[0].track?.trackId ?? "-1"
                                                                XCTAssertTrue(trackId.compare(firstNewTrackId) != .orderedSame, "Batches' first tracks are same")
                                                            } catch {
                                                                print(error)
                                                                XCTAssert(false, "Empty Radio station tracks list: " + error.localizedDescription)
                                                            }
                                                            exp.fulfill()
                                                        }
                                                    } catch {
                                                        print(error)
                                                        XCTAssert(false, "Radio station start track skip event send fail: " + error.localizedDescription)
                                                    }
                                                }
                                            } catch {
                                                print(error)
                                                XCTAssert(false, "Radio station start track skip event send fail: " + error.localizedDescription)
                                            }
                                        }
                                    } catch {
                                        print(error)
                                        XCTAssert(false, "Radio station start track event send fail: " + error.localizedDescription)
                                    }
                                }
                            } catch {
                                print(error)
                                XCTAssert(false, "Empty Radio station tracks list: " + error.localizedDescription)
                            }
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Radio station start listening event send fail: " + error.localizedDescription)
                    }
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations dashboard object: " + error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 15) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testRadioStationSettingsResponse() {
        let stationId = "genre:pop"
        let exp = self.expectation(description: "Request time-out expectation")
        client.setRadioStationSettings(stationId: stationId, language: .any, moodEnergy: .active, diversity: .defaultDiversity, type: .rotor) {
            result in
            do {
                let success = try result.get()
                XCTAssertTrue(success, "Radio stations list is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty Radio stations list: " + error.localizedDescription)
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
