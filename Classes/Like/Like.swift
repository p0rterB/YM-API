//
//  Like.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represents object with marker 'I like this'
public class Like: Decodable {
    
    //Note: В поле `type` содержится одно из трёх значений: `artist`, `playlist`, `album`. Обозначает поле, в котором содержится информация.
    
    ///Object type
    public let type: String?
    ///'Like' marker' UID
    public let id: String
    ///Date and time of adding marker
    public let timestamp: String?
    ///Liked album
    public let album: Album?
    ///Liked artist
    public let artist: Artist?
    ///Liked playlist
    public let playlist: Playlist?
    ///Short description
    public let shortDescription: String?
    ///Full description
    public let description: String?
    ///'Premier' marker
    public let isPremiere: Bool?
    ///'Banner appearance' marker
    public let isBanner: Bool?
    
    public init(type: String?, id: String, timestamp: String?, album: Album?, artist: Artist?, playlist: Playlist?, shortDescription: String?, description: String?, isPremiere: Bool?, isBanner: Bool?) {
        self.id = id
        self.type = type

        self.album = album
        self.artist = artist
        self.playlist = playlist
        self.timestamp = timestamp
        self.shortDescription = shortDescription
        self.description = description
        self.isPremiere = isPremiere
        self.isBanner = isBanner
    }
}
