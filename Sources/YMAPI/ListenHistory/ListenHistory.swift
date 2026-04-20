//
//  ListenHistory.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import Foundation

///Represents history of listened tracks for account
public class ListenHistory: Decodable {
    
    ///Object types (artists, playlists, albums etc) with tracks data
    public let contexts: [ListenHistoryItem]
    //public let otherTracks: [TrackShortOld]?
    
    public init(contexts: [ListenHistoryItem]) {
        self.contexts = contexts
    }
}
