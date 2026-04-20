//
//  SearchFeedback.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import Foundation

///Represents search feedback object
public class SearchFeedback: Encodable {
    
    ///TODO
    public let absoluteBlockPosition: Int
    ///TODO
    public let absolutePosition: Int
    ///TODO
    public let blockPosition: Int
    ///Found object type (album, artist, track, playlist etc)
    public let blockType: String
    ///Transfer type. Available values: navigate, play, like
    public let clickType: String
    ///Search request timestamp at client app
    public let clientNow: String
    ///Found object ID
    public let entityId: String
    ///Search response page index
    public let page: Int
    ///Found object position at page
    public let position: Int
    ///Search query text
    public let query: String
    ///Search reqeust ID
    public let searchRequestId: String
    ///Search request timestamp
    public let timestamp: String
    
    public init(absBlockPosition: Int, absPosition: Int, blockPosition: Int, blockType: String, clickType: String = "navigate", clientNow: String, entityId: String, page: Int, position: Int, query: String, searchRequestId: String, timestamp: String) {
        self.absoluteBlockPosition = absBlockPosition
        self.absolutePosition = absPosition
        self.blockPosition = blockPosition
        self.blockType = blockType
        self.clickType = clickType
        self.clientNow = clientNow
        self.entityId = entityId
        self.page = page
        self.position = position
        self.query = query
        self.searchRequestId = searchRequestId
        self.timestamp = timestamp
    }
    
    public init(absBlockPosition: Int, absPosition: Int, blockPosition: Int, blockType: String, clickType: String = "navigate", entityId: String, page: Int, position: Int, query: String, searchRequestId: String) {
        self.absoluteBlockPosition = absBlockPosition
        self.absolutePosition = absPosition
        self.blockPosition = blockPosition
        self.blockType = blockType
        self.clickType = clickType
        self.clientNow = DateUtil.isoFormat()
        self.entityId = entityId
        self.page = page
        self.position = position
        self.query = query
        self.searchRequestId = searchRequestId
        self.timestamp = DateUtil.isoFormat()
    }
}
