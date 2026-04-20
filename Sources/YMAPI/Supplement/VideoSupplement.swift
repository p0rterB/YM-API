//
//  VideoSupplement.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Track videoclips
public class VideoSupplement: Decodable {
    
    ///Video cover image url
    public let cover: String
    ///Video service provider
    public let provider: String
    ///Video name
    public let title: String?
    ///Video UID
    public let providerVideoId: String?
    ///Video url
    public let url: String?
    ///Video url on Yandex
    public let embedUrl: String?
    ///Video embedding HTML tag
    public let embed: String?
    
    public init(cover: String, provider: String, title: String?, providerID: String?, url: String?, embedUrl: String?, embed: String?) {
        self.cover = cover
        self.provider = provider

        self.title = title
        self.providerVideoId = providerID
        self.url = url
        self.embedUrl = embedUrl
        self.embed = embed
    }
}
