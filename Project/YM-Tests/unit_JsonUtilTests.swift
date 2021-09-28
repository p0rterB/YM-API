//
//  unit_JsonUtilTests.swift
//  YM-macTests
//
//  Created by Developer on 20.07.2021.
//

import XCTest
#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class unit_JsonUtilTests: XCTestCase {
    
    func testEmptyJsonExtract()
    {
        XCTAssertNil(JsonUtil.extractData(from: "", key: "someKey"))
    }
    
    func testJsonExtractSingleComplexObject()
    {
        let value = "{\"invocationInfo\":{\"hostname\":\"music-stable-back-vla-25.vla.yp-c.yandex.net\",\"req-id\":\"1626764808860545-17410853620659866484\",\"exec-duration-millis\":\"51\"},\"result\":{\"account\":{\"now\":\"2021-07-20T07:06:48+00:00\",\"uid\":12345678,\"login\":\"someLogin\",\"region\":123,\"fullName\":\"Full Name\",\"secondName\":\"Name\",\"firstName\":\"Full\",\"displayName\":\"someLogin\",\"birthday\":\"1970-01-01\",\"serviceAvailable\":true,\"hostedUser\":false,\"registeredAt\":\"2020-10-29T07:53:43+00:00\"},\"permissions\":{\"until\":\"2021-07-21T07:06:48+00:00\",\"values\":[\"landing-play\",\"feed-play\",\"radio-play\",\"mix-play\",\"play-radio-full-tracks\"],\"default\":[\"landing-play\",\"feed-play\",\"radio-play\",\"mix-play\",\"play-radio-full-tracks\"]},\"subscription\":{\"hadAnySubscription\":false,\"canStartTrial\":false,\"mcdonalds\":false},\"subeditor\":false,\"subeditorLevel\":0,\"pretrialActive\":false,\"advertisement\":\"Оформите постоянную подписку – первый месяц бесплатно!\",\"plus\":{\"hasPlus\":false,\"isTutorialCompleted\":false},\"defaultEmail\":\"email@yandex.com\",\"userhash\":\"b9b2755d0708d7d2115ee8ef8d8e477c40e6619637e0ee9afb8f636b347c07bf\"}}"
        
        let expected = "{\"account\":{\"now\":\"2021-07-20T07:06:48+00:00\",\"uid\":12345678,\"login\":\"someLogin\",\"region\":123,\"fullName\":\"Full Name\",\"secondName\":\"Name\",\"firstName\":\"Full\",\"displayName\":\"someLogin\",\"birthday\":\"1970-01-01\",\"serviceAvailable\":true,\"hostedUser\":false,\"registeredAt\":\"2020-10-29T07:53:43+00:00\"},\"permissions\":{\"until\":\"2021-07-21T07:06:48+00:00\",\"values\":[\"landing-play\",\"feed-play\",\"radio-play\",\"mix-play\",\"play-radio-full-tracks\"],\"default\":[\"landing-play\",\"feed-play\",\"radio-play\",\"mix-play\",\"play-radio-full-tracks\"]},\"subscription\":{\"hadAnySubscription\":false,\"canStartTrial\":false,\"mcdonalds\":false},\"subeditor\":false,\"subeditorLevel\":0,\"pretrialActive\":false,\"advertisement\":\"Оформите постоянную подписку – первый месяц бесплатно!\",\"plus\":{\"hasPlus\":false,\"isTutorialCompleted\":false},\"defaultEmail\":\"email@yandex.com\",\"userhash\":\"b9b2755d0708d7d2115ee8ef8d8e477c40e6619637e0ee9afb8f636b347c07bf\"}"
        guard let actual = JsonUtil.extractData(from: value, key: "result") else {
            XCTAssert(false, "Unable to extract json value")
            return
        }
        XCTAssert(actual.compare(expected) == .orderedSame, "Incorrect data in extracted value. Expected - " + expected + "\nActual - " + actual)
    }
    
    func testJsonExtractComplexObjectArray() {
        let value = "{\"invocationInfo\":{\"req-id\":\"1626851171541256-13443002316076885220\",\"hostname\":\"music-stable-back-sas-22.sas.yp-c.yandex.net\",\"exec-duration-millis\":3},\"result\":[{\"id\":\"51965869\",\"realId\":\"51965869\",\"title\":\"Timebomb\",\"contentWarning\":\"explicit\",\"major\":{\"id\":251,\"name\":\"AWAL\"},\"available\":true,\"availableForPremiumUsers\":true,\"availableFullWithoutPermission\":false,\"storageDir\":\"51327_109b74ca.36526310.1.609676\",\"durationMs\":195040,\"fileSize\":0,\"normalization\":{\"gain\":-9.93,\"peak\":32395},\"r128\":{\"i\":-5.95,\"tp\":-0.07},\"previewDurationMs\":30000,\"artists\":[{\"id\":4699882,\"name\":\"MXMS\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"uri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"prefix\":\"540e5208.a.7956489-3\"},\"genres\":[]}],\"albums\":[{\"id\":7956489,\"title\":\"Funeral Pop I\",\"metaType\":\"music\",\"contentWarning\":\"explicit\",\"year\":2019,\"releaseDate\":\"2019-05-01T00:00:00+03:00\",\"coverUri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"genre\":\"alternative\",\"buy\":[],\"trackCount\":6,\"likesCount\":50,\"recent\":false,\"veryImportant\":false,\"artists\":[{\"id\":4699882,\"name\":\"MXMS\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"uri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"prefix\":\"540e5208.a.7956489-3\"},\"genres\":[]}],\"labels\":[{\"id\":1408764,\"name\":\"We Are: The Guard\"}],\"available\":true,\"availableForPremiumUsers\":true,\"availableForMobile\":true,\"availablePartially\":false,\"bests\":[46182784,51965869],\"trackPosition\":{\"volume\":1,\"index\":5}}],\"coverUri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"lyricsAvailable\":false,\"type\":\"music\",\"rememberPosition\":false,\"trackSharingFlag\":\"COVER_ONLY\"}]}"
        let expected = "[{\"id\":\"51965869\",\"realId\":\"51965869\",\"title\":\"Timebomb\",\"contentWarning\":\"explicit\",\"major\":{\"id\":251,\"name\":\"AWAL\"},\"available\":true,\"availableForPremiumUsers\":true,\"availableFullWithoutPermission\":false,\"storageDir\":\"51327_109b74ca.36526310.1.609676\",\"durationMs\":195040,\"fileSize\":0,\"normalization\":{\"gain\":-9.93,\"peak\":32395},\"r128\":{\"i\":-5.95,\"tp\":-0.07},\"previewDurationMs\":30000,\"artists\":[{\"id\":4699882,\"name\":\"MXMS\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"uri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"prefix\":\"540e5208.a.7956489-3\"},\"genres\":[]}],\"albums\":[{\"id\":7956489,\"title\":\"Funeral Pop I\",\"metaType\":\"music\",\"contentWarning\":\"explicit\",\"year\":2019,\"releaseDate\":\"2019-05-01T00:00:00+03:00\",\"coverUri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"genre\":\"alternative\",\"buy\":[],\"trackCount\":6,\"likesCount\":50,\"recent\":false,\"veryImportant\":false,\"artists\":[{\"id\":4699882,\"name\":\"MXMS\",\"various\":false,\"composer\":false,\"cover\":{\"type\":\"from-album-cover\",\"uri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"prefix\":\"540e5208.a.7956489-3\"},\"genres\":[]}],\"labels\":[{\"id\":1408764,\"name\":\"We Are: The Guard\"}],\"available\":true,\"availableForPremiumUsers\":true,\"availableForMobile\":true,\"availablePartially\":false,\"bests\":[46182784,51965869],\"trackPosition\":{\"volume\":1,\"index\":5}}],\"coverUri\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"ogImage\":\"avatars.yandex.net/get-music-content/1880735/540e5208.a.7956489-3/%%\",\"lyricsAvailable\":false,\"type\":\"music\",\"rememberPosition\":false,\"trackSharingFlag\":\"COVER_ONLY\"}]"
        guard let actual = JsonUtil.extractData(from: value, key: "result") else {
            XCTAssert(false, "Unable to extract json value")
            return
        }
        XCTAssert(actual.compare(expected) == .orderedSame, "Incorrect data in extracted value. Expected - " + expected + "\nActual - " + actual)
    }
}
