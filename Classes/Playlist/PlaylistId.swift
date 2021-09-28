//
//  PlaylistId.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Playlist ID info
public class PlaylistId: Decodable {
    
    ///Playlist owner user Id
    public let uid: Int
    ///Playlist type UID
    public let kind: Int

    public init(uid: Int, kind: Int) {
        self.uid = uid
        self.kind = kind
    }
}
