//
//  TestConstants.swift
//  YM-macTests
//
//  Created by Developer on 16.07.2021.
//

#if canImport(YmuzApiMac)
@testable import YmuzApiMac
#endif
#if canImport(YmuzApi)
@testable import YmuzApi
#endif

class TestConstants
{    
    /*public static let login: String = "YOUR_LOGIN_OR_EMAIL"
    public static let pass: String = "YOUR_PASS"

    public static let token: String = "YOUR_TOKEN"//after login you can paste got token here
    public static let uid: Int = 12345678//your account uid*/

    public static let device: YMDevice = YMDevice(os: "Android", osVer: "5.1.1", manufacturer: "Samsung", model: "GT-I9500", clid: "google-play", deviceId: "b4cd324ad1ec4da18b5d216aab8e93ac", uuid: "cd3288ff24756a6075c1c6ae5de4416a")
    public static let apiLang: ApiLanguage = .ru
}
