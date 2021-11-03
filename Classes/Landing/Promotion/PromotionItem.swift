//
//  PromotionItem.swift
//  YM-API
//
//  Created by Developer on 15.10.2021.
//

import Foundation

public class PromotionPlaylist: Decodable {
    public let playlist: Playlist?
    
    public init(playlist: Playlist?) {
        self.playlist = playlist
    }
}
