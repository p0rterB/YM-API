//
//  LyricsDownloadInfo.swift
//  YM-API
//
//  Created by Developer on 02.03.2023.
//

import Foundation

///Represents track lyrics download info
public class LyricsDownloadInfo: Decodable {
    
    ///Formatted text file url, which contains track lyrics. Without subscription contains nothing
    public let downloadUrl: String
    public let lyricId: Int
    public let externalLyricId: String
    public let writers: [String]?
    public let major: Major
    
    public init(downloadUrl: String, lyricId: Int, externalLyricId: String, writers: [String]?, major: Major) {
        self.downloadUrl = downloadUrl
        self.lyricId = lyricId
        self.externalLyricId = externalLyricId
        self.writers = writers
        self.major = major
    }
}
