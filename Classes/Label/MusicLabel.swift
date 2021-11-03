//
//  Label.swift
//  YM-API
//
//  Created by Developer on 15.10.2021.
//

import Foundation

///Represents music label
public class MusicLabel: Decodable {
    public let pager: Pager
    public let artists: [Artist]?
    public let albums: [Album]?
    
    public init(pager: Pager, artists: [Artist]?, albums: [Album]?) {
        self.pager = pager
        self.albums = albums
        self.artists = artists
    }
}
