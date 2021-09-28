//
//  TrackShortOld.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Short track version
public class TrackShortOld: Decodable {
    
    //Note: Данная версия менее богата полями и найдена позже первой, поэтому была принята как за старую версию. Другая версия сокращённого трека: :class:`yandex_music.TrackShort`.
    
    ///Track UID
    public let track_id: TrackId?
    ///Date TODO
    public let timestamp: String

    public init(track_id: TrackId?, timestamp: String) {
        self.track_id = track_id
        self.timestamp = timestamp
    }
}
