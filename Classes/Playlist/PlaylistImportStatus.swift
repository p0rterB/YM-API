//
//  PlaylistImportStatus.swift
//  YM-API
//
//  Created by Developer on 12.05.2022.
//

import Foundation

///Represents playlist import check status
public class PlaylistImportStatus: Decodable {
    
    ///Import status
    public let status: String
    ///Playlist import complete trigger
    public var done: Bool {
        get {return status == "done"}
    }
    ///Imported playlist info
    public let playlists: [Playlist]?
    
    public init(status: String, playlists: [Playlist]?) {
        self.status = status
        self.playlists = playlists
    }
}
