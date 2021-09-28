//
//  DateUtil-tests.swift
//  yandexMusic-macTests
//
//  Created by Developer on 14.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_DateUtilTests: XCTestCase {

    func testDateIsoFormat()
    {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.year = 2020
        dateComponents.month = 10
        dateComponents.day = 10
        dateComponents.hour = 10
        dateComponents.minute = 10
        dateComponents.second = 50
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = calendar.date(from: dateComponents) else {XCTAssert(false, "Unable to build date from components"); return}
        
        let expected = "2020-10-10T10:10:50Z"

        let actual = DateUtil.isoFormat(date: date)
        XCTAssertTrue(actual.compare(expected) == .orderedSame, "expected:" + expected + "|actual:" + actual)
    }
}
