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
    public static let login: String = "LOGIN"
    public static let pass: String = "PASS"
    
    public static let xToken: String = "YOUR_XTOKEN"//after success pasword auth you can paste x_token here
    public static let token: String = "YM_TOKEN"//after login you can paste got token here
    public static let uid: Int = -1//your account uid

    public static let device: YMDevice = YMDevice(os: "Android", osVer: "5.1.1", manufacturer: "Samsung", name: "myPhone", platform: "phone", model: "GT-I9500", clid: "google-play", deviceId: "b4cd324ad1ec4da18b5d216aab8e93ac", uuid: "cd3288ff24756a6075c1c6ae5de4416a")
    public static let apiLang: ApiLanguage = .ru
}
