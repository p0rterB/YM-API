//
//  SearchHistoryItem.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import Foundation

///Represents search history object
public class SearchHistoryItem: Decodable {
    
    ///Type of the object
    public let type: String
    ///Optional search history item content - playlist
    public let playlist: Playlist?
    ///Optional search history item content - album
    public let album: Album?
    ///Optional search history item content - track
    public let track: Track?
    ///Optional search history item content - artist
    public let artist: Artist?
    
    public init(type: String, playlist: Playlist?, album: Album?, track: Track?, artist: Artist?) {
        self.type = type
        self.playlist = playlist
        self.album = album
        self.track = track
        self.artist = artist
    }
}
