//
//  LandingList.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Landing objects
public class LandingList: Decodable {
    //Note: Известные значения поля `type`: `new-playlists`, `new-releases`, `podcasts`. В зависимости от типа будет заполнено то, или иное поле.
    
    ///Result type
    public let type: String
    ///Event source
    public let typeForFrom: String
    ///Page title
    public let title: String
    ///List UID
    public let id: String?
    ///New albums
    public let newReleases: [Int]?
    ///New playlists
    public let newPlaylists: [PlaylistId]?
    ///Podcasts
    public let podcasts: [Int]?
    
    public init(type: String, typeForFrom: String, title: String, id: String?, newReleases: [Int]?, newPlaylists: [PlaylistId]?, podcasts: [Int]?) {
        self.type = type
        self.typeForFrom = typeForFrom
        self.title = title

        self.id = id
        self.newReleases = newReleases
        self.newPlaylists = newPlaylists
        self.podcasts = podcasts
    }
}
