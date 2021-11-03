//
//  ListenHistory.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import Foundation

///Represents recent listen history object
public class ListenHistoryItem: Decodable {
    
    ///Yandex Music app type
    public let client: String
    ///Object type
    public let context: String
    ///Object ID
    public let contextItem: Int
    ///Object children tracks data
    public let tracks: [TrackShortOld]
    
    public init(client: String, context: String, contextItem: Int, tracks: [TrackShortOld]) {
        self.client = client
        self.context = context
        self.contextItem = contextItem
        self.tracks = tracks
    }
}
