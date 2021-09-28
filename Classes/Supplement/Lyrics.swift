//
//  Lyrics.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Track lyrics
public class Lyrics: Decodable {
    
    ///Track lyrics UID
    public let id: Int
    ///Short track lyrics (first lines)
    public let lyrics: String
    ///Track full lyrics
    public let fullLyrics: String
    ///Rights accessibility marker
    public let hasRights: Bool
    ///Lyrics translation accessibility marker
    public let showTranslation: Bool
    ///Track lyrics language
    public let textLanguage: String?
    ///Track lyrics translation source url
    public let url: String?

    public init(id: Int, lyrics: String, fullLyrics: String, hasRights: Bool, showTranslation: Bool, textLanguage: String?, url: String?) {
        self.id = id
        self.lyrics = lyrics
        self.fullLyrics = fullLyrics
        self.hasRights = hasRights
        self.showTranslation = showTranslation

        self.textLanguage = textLanguage
        self.url = url
    }
}
