//
//  Best.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Best relevant search result item
public class Best: Decodable {
    
    enum CodingKeys: CodingKey {
        case type
        case result
        case text
    }
    
    ///Type of item
    public let type: String
    ///Best result data object
    public let result: YMBaseObject?//result: Optional[Union[Track, Artist, Album, Playlist, Video]],
    ///TODO
    public let text: String?
    
    public init(type: String, result: Track?, text: String?) {
        self.type = type
        self.result = result
        self.text = text
    }
        
    public init(type: String, result: Artist?, text: String?) {
        self.type = type
        self.result = result
        self.text = text
    }
    
    public init(type: String, result: Album?, text: String?) {
        self.type = type
        self.result = result
        self.text = text
    }
    
    public init(type: String, result: Playlist?, text: String?) {
        self.type = type
        self.result = result
        self.text = text
    }
    
    public init(type: String, result: Video?, text: String?) {
        self.type = type
        self.result = result
        self.text = text
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var type = ""
        do {
            type = try container.decode(String.self, forKey: .type)
        } catch {
            type = "unknown"
        }
        self.type = type
        self.text = try? container.decodeIfPresent(String.self, forKey: .text)
        //result: Optional[Union[Track, Artist, Album, Playlist, Video]],
        if let g_podcast = try? container.decodeIfPresent(Podcast.self, forKey: .result) {
            self.result = g_podcast
        } else if let g_track = try? container.decodeIfPresent(Track.self, forKey: .result) {
            self.result = g_track
        } else if let g_artist = try? container.decodeIfPresent(Artist.self, forKey: .result) {
            self.result = g_artist
        } else if let g_album = try? container.decodeIfPresent(Album.self, forKey: .result) {
            self.result = g_album
        } else if let g_playlist = try? container.decodeIfPresent(Playlist.self, forKey: .result) {
            self.result = g_playlist
        } else if let g_video = try? container.decodeIfPresent(Video.self, forKey: .result) {
            self.result = g_video
        } else {
            self.result = nil
        }
    }
}
