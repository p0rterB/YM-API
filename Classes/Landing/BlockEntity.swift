//
//  BlockEntity.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represent block inner data
public class BlockEntity: Decodable {
    
    //Note: В зависимости от поля `type_`, в поле `data` будет объект соответствующего типа. Известные значения поля `type_`: `personal-playlist`, `promotion`, `album`, `playlist`, `chart-item`, `play-context`, `mix-link`.
    
    enum CodingKeys: CodingKey {
        case id
        case type
        case data
    }
    
    ///Entiy UID
    public let id: String
    ///Entity type
    public let type: String
    ///Entity data
    public let data: YMBaseObject?// Optional[Union['GeneratedPlaylist', 'Promotion', 'Album', 'Playlist', 'ChartItem', 'PlayContext', 'MixLink']]
    
    public init(id: String, type: String, data: GeneratedPlaylist?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: Promotion?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: Album?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: Playlist?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: ChartItem?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: PlayContext?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public init(id: String, type: String, data: MixLink?) {
        self.id = id
        self.type = type
        self.data = data
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)

        var data: YMBaseObject? = nil
        if (self.type.compare("chart-item") == .orderedSame) {
            data = try? container.decodeIfPresent(ChartItem.self, forKey: .data)
        }
        if (self.type.compare("album") == .orderedSame) {
            data = try? container.decodeIfPresent(Album.self, forKey: .data)
        }
        if (self.type.compare("playlist") == .orderedSame) {
            data = try? container.decodeIfPresent(Playlist.self, forKey: .data)
        }
        if (self.type.compare("promotion") == .orderedSame) {
            data = try? container.decodeIfPresent(Promotion.self, forKey: .data)
        }
        if (self.type.compare("personal-playlist") == .orderedSame) {
            data = try? container.decodeIfPresent(GeneratedPlaylist.self, forKey: .data)
        }
        if (self.type.compare("play-context") == .orderedSame) {
            data = try? container.decodeIfPresent(PlayContext.self, forKey: .data)
        }
        if (self.type.compare("mix-link") == .orderedSame) {
            data = try? container.decodeIfPresent(MixLink.self, forKey: .data)
        }
        self.data = data
    }
}
