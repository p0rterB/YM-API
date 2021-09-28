//
//  ArtistTracks.swift
//  yandexMusic-iOS
//
//  Created by Developer on 10.06.2021.
//

import Foundation

///Represents artist's tracks list
public class ArtistTracks: Decodable {
    
    ///Artist's tracks list
    public let tracks: [Track]
    ///Tracks paginator
    public let pager: Pager?

    public init(tracks: [Track], pager: Pager?) {
        self.tracks = tracks
        self.pager = pager
    }
}
