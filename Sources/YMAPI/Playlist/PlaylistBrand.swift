//
//  PlaylistBrand.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Playlist brand
public class PlaylistBrand: Decodable {
    //Note: Отслеживание просмотров на сторонник сервисах бренда, рекомендация следующего контента.
    
    ///Playlist image url
    public let image: String
    ///Background color
    public let background: String
    ///Playlist content url
    public let reference: String
    ///Shows tracker url (gif image [web beacon])
    public let pixels: [String]
    ///Interface theme
    public let theme: String
    ///Playlist theme TODO
    public let playlistTheme: String
    ///Button title
    public let button: String

    public init(image: String, background: String, reference: String, pixels: [String], theme: String, playlistTheme: String, button: String) {
        self.image = image
        self.background = background
        self.reference = reference
        self.pixels = pixels
        self.theme = theme
        self.playlistTheme = playlistTheme
        self.button = button
    }        
}
