//
//  PlaylistAbsence.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Playlist absence info
public class PlaylistAbsence: Decodable {
    
    ///Playlist type UID
    public let kind: Int
    ///Playlist absence reason description
    public let reason: String

    public init(kind: Int, reason: String) {
        self.kind = kind
        self.reason = reason
    }
}
