//
//  Event.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represent feed event
public class FeedEvent: Decodable {
    
    //Note: Известные значения поля `type_`: `tracks`, `artists`, `albums`, `notification`. Поле `message` заполнено только когда `type` равен `notification`. Примером значения поля `type_for_from` может служить `recommended-similar-artists`. Наличие данных в `tracks`, `albums`, `artists` напрямую зависит от `type_`.
    
    ///Event UID
    public let id: String
    ///Event type
    public let type: String
    ///Event source
    public let typeForFrom: String?
    ///Event title
    public let title: String?
    ///Related to event tracks
    public let tracks: [Track]?
    ///Artists with similar and popular tracks
    public let artists: [ArtistEvent]?
    ///Albums list with tracks
    public let albums: [AlbumEvent]?
    ///Event message
    public let message: String?
    ///Event device source
    public let device: String?
    ///Tracks count (possible, deprecated)
    public let tracksCount: Int?
    ///Tracks genre
    public let genre: String?

    public init(id: String,
                type: String,
                typeForFrom: String?,
                title: String?,
                tracks: [Track]?,
                artists: [ArtistEvent]?,
                albums: [AlbumEvent]?,
                message: String?,
                device: String?,
                tracksCount: Int?,
                genre: String?) {
        self.id = id
        self.type = type

        self.typeForFrom = typeForFrom
        self.title = title
        self.tracks = tracks
        self.albums = albums
        self.artists = artists
        self.message = message
        self.device = device
        self.tracksCount = tracksCount
        self.genre = genre
    }
}
