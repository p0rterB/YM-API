//
//  AppService.swift
//  Rave
//
//  Created by Admin on 14.05.2021.
//  Copyright © 2020 Zeit. All rights reserved.
//

import Foundation
import AVFoundation
import YmuzApi

var appService = AppService.shared
let client = appService.client
var playerQueue = appService.playerQueue

class AppService
{
    fileprivate static let TOKEN_KEY: String = "userToken"
    static var shared = AppService()
    
    var likedLibrary: LikeLibrary?
    var dislikedLibrary: LikeLibrary?
    var properties: Properties
    var playerQueue: PlayerQueue
    var client: YMClient
    
    init() {
        properties = Properties.load()
        playerQueue = PlayerQueue(queueKey: 0, tracks: [], playIndex: -1, playNow: false, playerWidgetDelegate: nil, delegate: nil)
        let device = YMDevice(os: "iOS", osVer: FeedbackInfoCarver.osVer, manufacturer: "Apple", model: FeedbackInfoCarver.model, clid: "app-store", deviceId: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased(), uuid: UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased())
        let lang = ApiLanguage.ru
        if (properties.isAuthed) {
            client = YMClient.initialize(device: device, lang: lang, uid: properties.uid, token: AppService.getToken())
        } else {
            client = YMClient.initialize(device: device, lang: lang)
        }
    }
    
    class func localizedString(_ string_key: LocalizationKeys) -> String
    {
        return string_key.localizedString(for: appService.properties.locale)
    }
    
    class func saveToken(_ value: String) {
        if let data = value.data(using: String.Encoding.utf8, allowLossyConversion: false)
        {
            let status = SecureStorage.save(key: TOKEN_KEY, data: data)
            if status != errSecSuccess
            {
                print("Error during saving auth_token")
            }
        }
    }
    class func getToken() -> String {
        guard let data = SecureStorage.load(key: TOKEN_KEY) else {return ""}
        guard let str = String(data: data, encoding: .utf8) else {return ""}
        return str
    }
}
