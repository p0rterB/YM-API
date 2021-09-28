//
//  PlayContextData.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represent playable data of context
public class PlayContextData: YMBaseObject, Decodable {
    
    ///other tracks of context
    public let otherTracks: [TrackShortOld]

    public init(otherTracks: [TrackShortOld]) {
        self.otherTracks = otherTracks
    }
}
