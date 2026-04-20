//
//  TrackSimilar.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//
///Similar compositions of the defined track
public class TracksSimilar: Decodable {
    
    ///The defined track
    public let track: Track?
    /// Similar to the defined track compositions
    public let similarTracks: [Track]
    
    public init(track: Track?, similarTracks: [Track]) {
        self.track = track
        self.similarTracks = similarTracks
    }
}
