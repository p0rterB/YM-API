//
//  TrackWithAds.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

public class TrackWithAds: Decodable {
    //Note:Поле `type` встречалось только с значением `track`.
    
    ///Type TODO
    public let type: String
    ///Track
    public let track: Track?

    public init(type: String, track: Track?) {
        self.type = type
        self.track = track
    }
}
