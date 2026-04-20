//
//  MetaData.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Track meta data
public class MetaData: Decodable {
    
    ///Ablum name
    public let album: String?
    ///Number of the album's disk (volume)
    public let volume: Int?
    ///Release year
    public let year: Int?
    ///Track position on the album
    public let number: Int?
    ///Track genre
    public let genre: String?
    ///Track lyrics. NOTICE: There are only on user-uploaded tracks
    public let lyricist: String?
    ///Version TODO
    public let version:String?
    ///Track compositor TODO
    public let composer: String?

    public init(album: String?, volume: Int?, year: Int?, number: Int?, genre: String?, lyricist: String?, version:String?, composer: String?) {
        self.album = album
        self.volume = volume
        self.year = year
        self.number = number
        self.genre = genre
        self.lyricist = lyricist
        self.version = version
        self.composer = composer
    }
}
