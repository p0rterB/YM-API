//
//  TagResult.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Tag and related for it playlists
public class TagResult: Decodable {
    ///Tag
    public let tag: Tag
    ///Related for current tag playlists IDs
    public let ids: [PlaylistId]
    
    public init(tag: Tag, ids: [PlaylistId]) {
        self.tag = tag
        self.ids = ids
    }
}
