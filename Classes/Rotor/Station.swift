//
//  Station.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Represents radio station
public class Station: Decodable {
    //Note:`id_for_from` обозначает предка станции, например, жанр, настроение или занятие. Неизвестно когда используется `id_for_from`, а когда `parent_id`.
    
    ///Radio station UID
    public let id: RadioId?
    ///Radio station name
    public let name: String
    ///Radio station icon
    public let icon: Icon
    ///Radio station icon
    public let mtsIcon: Icon?
    ///Radio station icon
    public let geocellIcon: Icon?
    ///Radio station category (type)
    public let idForFrom: String
    ///Legacy radio station restrictions settings
    public let restrictions: RadioRestrictions
    ///Radio station restrictions settings
    public let restrictions2: RadioRestrictions
    ///Radio station full iamge url
    public let fullImageUrl: String?
    ///Radio station full iamge url
    public let mtsFullImageUrl: String?
    ///Parent radio station UID
    public let parentId: RadioId?
    
    ///Radio station ID
    public var radioId: String? {
        return id?.stationId
    }
    
    public init(id: RadioId?, name: String, icon: Icon, mtsIcon: Icon?, geocellIcon: Icon?, idForFrom: String, restrictions: RadioRestrictions, restrictions2: RadioRestrictions, fullImgUrl: String?, mtsFullImgUrl: String?, parentId: RadioId?) {
        self.id = id
        self.name = name
        self.icon = icon
        self.mtsIcon = mtsIcon
        self.geocellIcon = geocellIcon
        self.idForFrom = idForFrom
        self.restrictions = restrictions
        self.restrictions2 = restrictions2

        self.fullImageUrl = fullImgUrl
        self.mtsFullImageUrl = mtsFullImgUrl
        self.parentId = parentId

        
    }
        
}
