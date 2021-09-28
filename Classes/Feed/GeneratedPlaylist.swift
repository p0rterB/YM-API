//
//  GeneratedPlaylist.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Back-end generated playlist
public class GeneratedPlaylist: YMBaseObject, Decodable {
    
    ///Playlist type
    public let type: String
    ///Ready for playing playlist marker
    public let ready: Bool
    ///User notified about updates marker
    public let notify: Bool
    ///Generated playlist
    public let data: Playlist?
    ///Palylist description TODO
    public let description: [String]?

    public init(type: String, ready: Bool, notify: Bool, data: Playlist?, description: [String]?) {
        self.type = type
        self.ready = ready
        self.notify = notify
        self.data = data

        self.description = description
    }
}
