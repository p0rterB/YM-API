//
//  TrackShortOld.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Short track version (contains in recent listen blocks)
public class TrackShortOld: Decodable {

    ///Track UID
    public let trackId: TrackId?
    ///Recent listen date
    public let timestamp: String

    public init(trackId: TrackId?, timestamp: String) {
        self.trackId = trackId
        self.timestamp = timestamp
    }
}
