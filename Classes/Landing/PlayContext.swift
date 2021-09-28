//
//  PlayContext.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents playable context
public class PlayContext: YMBaseObject, Decodable {
    
    //Note: Известные значения поля `client_`: `android`. Поле `context` хранит в себе место воспроизведения, например, `playlist`. Поле `context_item` хранит в себе уникальный идентификатор context'a, т.е. в нашем случае playlist'a.
    
    enum CodingKeys: CodingKey {
        case client
        case context
        case contextItem
        case tracks
        case payload
    }
    
    ///Client name
    public let client: String
    ///Context type
    public let context: String
    ///Context item ID
    public let contextItem: String
    ///Context tracks
    public let tracks: [TrackShortOld]?
    ///Play context item
    public let payload: YMBaseObject?

    public init(client: String, context: String, contextItem: String, tracks: [TrackShortOld]?, payload: YMBaseObject?) {
        self.client = client
        self.context = context
        self.contextItem = contextItem
        self.tracks = tracks
        self.payload = payload
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.client = try container.decode(String.self, forKey: .client)
        self.context = try container.decode(String.self, forKey: .context)
        self.contextItem = try container.decode(String.self, forKey: .contextItem)
        self.tracks = try? container.decodeIfPresent([TrackShortOld].self, forKey: .tracks)
        var payload: YMBaseObject? = nil
        if (context.compare("playlist") == .orderedSame) {
            payload = try? container.decodeIfPresent(Playlist.self, forKey: .payload)
        }
        if (context.compare("album") == .orderedSame) {
            payload = try? container.decodeIfPresent(Album.self, forKey: .payload)
        }
        self.payload = payload
    }
}
