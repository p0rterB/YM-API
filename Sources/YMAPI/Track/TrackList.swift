//
//  TrackList.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Tracks list
public class TrackList: Decodable {
    
    ///User UID
    public let uid: Int
    ///Data revision TODO
    public let revision: Int
    ///Short tracks info array
    public let tracks: [TrackShort]
    ///Array with only tracks' ids
    public var tracksIds: [String] {
        get {
            return tracks.map { (trackShort) -> String in
                return String(trackShort.id)
            }
        }
    }

    public init(uid: Int, revision: Int, tracks: [TrackShort]) {
        self.uid = uid
        self.revision = revision
        self.tracks = tracks
    }
    
    public func fetchTracks(completion: @escaping (_ result: Result<[Track], YMError>) -> Void) {
        getTracksByApi(token: accountSecret, trackIds: tracksIds, positions: false, completion: completion)
    }
}
