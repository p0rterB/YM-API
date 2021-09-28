//
//  Supplement.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Additional info about the track
public class Supplement: Decodable {
    
    ///Track additional info UID
    public let id: String
    ///Track lyrics
    public let lyrics: Lyrics?
    ///Track videos
    public let videos: [VideoSupplement]?
    ///Radio availability marker
    public let radioIsAvailable: Bool?
    ///Podcast episode full description
    public let description: String?
    
    public init(id: String, lyrics: Lyrics?, videos: [VideoSupplement]?, radioAvailable: Bool?, description: String?) {
        self.id = id
        self.lyrics = lyrics
        self.videos = videos

        self.radioIsAvailable = radioAvailable
        self.description = description
    }
}
