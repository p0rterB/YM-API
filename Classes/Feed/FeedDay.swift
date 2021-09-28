//
//  FeedDay.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Feed for a day
public class FeedDay: Decodable {
    
    ///Date ('YYYY-MM-DD' format)
    public let day: String
    ///Events TODO
    public let events: [FeedEvent]
    ///Tracks to play with ads
    public let tracksToPlayWithAds: [TrackWithAds]
    ///Playable tracks
    public let tracksToPlay: [Track]
    
    public init(day: String, events: [FeedEvent], tracksToPlayWithAds: [TrackWithAds], tracksToPlay: [Track]) {
        self.day = day
        self.events = events
        self.tracksToPlayWithAds = tracksToPlayWithAds
        self.tracksToPlay = tracksToPlay
    }
}
