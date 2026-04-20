//
//  LikeLibrary.swift
//  YM-API
//
//  Created by Developer on 26.07.2021.
//
///Represents user likes storage
public class LikeLibrary: Decodable {
    ///Likes subject ID
    public let uid: Int
    ///Likes library revision number
    public let revision: Int
    ///Tracks' likes
    public var tracks: [LikeObject]?
    
    public init(uid: Int, revision: Int, tracks: [LikeObject]?) {
        self.uid = uid
        self.revision = revision
        self.tracks = tracks
    }
    
    public func add(track: Track) -> Bool {
        if (contains(track: track)) {
            return false
        } else if tracks != nil {
            tracks?.insert(LikeObject(id: track.id, albumId: nil, artist: nil, playlist: nil, timestamp: DateUtil.isoFormat()), at: 0)
        }
        return true
    }
    
    public func remove(track: Track) -> Bool {
        let index = findIndexFor(track: track)
        if (index < 0) {
            return true
        }
        tracks?.remove(at: index)
        return true
    }
    
    public func contains(track: Track) -> Bool {
        if let g_likes = tracks {
            for likedTrack in g_likes {
                guard let g_id = likedTrack.id else {continue}
                if (g_id.compare(track.id) == .orderedSame)
                {
                    return true
                }
            }
        }
        return false
    }
    
    public func findIndexFor(track: Track) -> Int {
        var index = -1
        if let g_likes = tracks, g_likes.count > 0 {
            for i in 0 ... g_likes.count - 1 {
                let likedTrack = g_likes[i]
                guard let g_id = likedTrack.id else {continue}
                if (g_id.compare(track.id) == .orderedSame)
                {
                    index = i
                    break
                }
            }
        }
        return index
    }
}
