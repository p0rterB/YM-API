//
//  ArtistAlbums.swift
//  yandexMusic-iOS
//
//  Created by Developer on 10.06.2021.
//

import Foundation

///Artist's albums list
public class ArtistAlbums: Decodable {
    
    ///Artist's albums list
    public let albums: [Album]
    ///Albums paginator
    public let pager: Pager?
    
    public init(albums: [Album], pager: Pager?) {
        self.albums = albums
        self.pager = pager
    }
}
