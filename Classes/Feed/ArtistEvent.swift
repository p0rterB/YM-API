//
//  ArtistEvent.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Feed event - artist
public class ArtistEvent: Decodable {
    
    ///Artist info of event
    public let artist: Artist?
    ///Tracks of event
    public let tracks: [Track]
    ///Similar artists to current from history
    public let similarToArtistsFromHistory: [Artist]?
    ///Event subscription marker
    public let subscribed: Bool?
    
    public init(artist: Artist?, tracks: [Track], similarToArtistsFromHistory: [Artist]?, subscribed: Bool?) {
        self.artist = artist
        self.tracks = tracks
        self.similarToArtistsFromHistory = similarToArtistsFromHistory

        self.subscribed = subscribed
    }
}
