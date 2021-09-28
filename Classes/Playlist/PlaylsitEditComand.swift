//
//  PlaylsitEditComand.swift
//  YM-API
//
//  Created by Developer on 02.09.2021.
//

//Represents playlist content change operation item
public class PlaylistEditCommand: Encodable {
    
    ///Edit command type (insert or delete)
    public let op: String
    
    ///Begin index for removing
    public let from: Int?
    ///End index for removing
    public let to: Int?
    
    ///Insert position
    public let at: Int?
    ///Tracks' IDs for insert
    public let tracks: [[String: Int]]?
    
    ///Initializes delete command
    public init(from: Int, to: Int) {
        self.op = "delete"
        self.from = from
        self.to = to
        at = nil
        tracks = nil
    }
    
    ///Initializes insert command
    public init(position: Int, tracksData:[TrackId]) {
        self.op = "insert"
        from = nil
        to = nil
        self.at = position
        var trackIds: [[String: Int]] = []
        for track in tracksData {
            if let g_albumdId = track.albumId {
                let trackId = track.id ?? track.trackId
                if let g_trackId = trackId {
                    trackIds.append([
                        "id": g_trackId,
                        "albumId": g_albumdId
                    ])
                }
            }
        }
        self.tracks = trackIds
    }
}
