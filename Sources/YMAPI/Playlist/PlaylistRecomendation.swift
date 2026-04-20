//
//  PlaylistRecommendation.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Recomedations for playlist
public class PlaylistRecommendation: Decodable {
    
    ///Recommended tracks list
    public let tracks: [Track]
    ///Tracks set UID
    public let batchId: String?

    public init(tracks: [Track], batchId: String?) {
        self.batchId = batchId
        self.tracks = tracks
    }
}
