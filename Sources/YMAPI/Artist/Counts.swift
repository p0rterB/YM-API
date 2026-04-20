//
//  Counts.swift
//  yandexMusic-iOS
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Artist properties counts
public class Counts: Decodable {
    
    ///Tracks count
    public let tracks: Int
    ///Direct albums count
    public let directAlbums: Int
    ///Additional albums count
    public let alsoAlbums: Int
    ///Additional tracks count
    public let alsoTracks: Int
    
    public init(tracks: Int, directAlbums: Int, alsoAlbums: Int, alsoTracks: Int) {
        self.tracks = tracks
        self.directAlbums = directAlbums
        self.alsoAlbums = alsoAlbums
        self.alsoTracks = alsoTracks
    }
}
