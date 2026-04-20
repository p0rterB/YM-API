//
//  Video.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

public class Video: YMBaseObject, Decodable {
    
    ///Video name
    public let title: String
    ///Video cover url
    public let cover: String?
    //Video url embed Yandex
    public let embedUrl: String?
    ///Video provider
    public let provider: String?
    ///Video id at provider
    public let providerVideoId: String?
    ///Youtube video url
    public let youtubeUrl: String?
    ///Video thumbnail url
    public let thumbnailUrl: String?
    ///Video duration in seconds
    public let duration: Int?
    ///Video description
    public let text: String?
    ///HTML tag for web page
    public let htmlAutoPlayVideoPlayer: String?
    ///Region TODO
    public let regions: [String]
    
    public init(title: String, cover: String?, embedUrl: String?, provider: String?, providerId: Int?, youtubeUrl: String?, thumbnailUrl: String?, duration: Int?, text: String?, htmlAutoPlay: String?, regions: [String]) {
        self.title = title

        self.cover = cover
        self.embedUrl = embedUrl
        self.provider = provider
        if let g_providerID = providerId {
            self.providerVideoId = String(g_providerID)
        } else {
            self.providerVideoId = nil
        }
        
        self.youtubeUrl = youtubeUrl
        self.thumbnailUrl = thumbnailUrl
        self.duration = duration
        self.text = text
        self.htmlAutoPlayVideoPlayer = htmlAutoPlay
        self.regions = regions
    }
    
    public init(title: String, cover: String?, embedUrl: String?, provider: String?, providerId: String?, youtubeUrl: String?, thumbnailUrl: String?, duration: Int?, text: String?, htmlAutoPlay: String?, regions: [String]) {
        self.title = title

        self.cover = cover
        self.embedUrl = embedUrl
        self.provider = provider
        self.providerVideoId = providerId
        self.youtubeUrl = youtubeUrl
        self.thumbnailUrl = thumbnailUrl
        self.duration = duration
        self.text = text
        self.htmlAutoPlayVideoPlayer = htmlAutoPlay
        self.regions = regions
    }
}
