//
//  AlbumEvent.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Feed event - album
public class AlbumEvent: Decodable {
    
    ///Album info of event
    public let album: Album?
    ///Tracks info of events
    public let tracks: [Track]
    
    public init(album: Album?, tracks: [Track]) {
        self.album = album
        self.tracks = tracks
    }
}
