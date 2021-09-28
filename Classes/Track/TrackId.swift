//
//  TrackId.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents track uid data
public class TrackId: Codable {
    
    //Note: Поле `track_id` используется только у объектах полученных через очередь треков. В остальные случаях `id`. Поле `from_` есть только у объект, которые используются в очереди треков.
    
    enum CodingKeys: CodingKey {
        case id
        case trackId
        case albumId
        case from
    }
    
    ///Track UID
    public let id: Int?
    ///Track UID
    public let trackId: Int?
    ///Album UID
    public let albumId: Int?
    ///Track source
    public let from: String?

    public var trackFullId: String {
        var fullId: String = String(id ?? 0)
        if let g_trackId = trackId {
            fullId = String(g_trackId)
        }
        if let g_albumId = albumId {
            fullId += ":" + String(g_albumId)
        }
        return fullId
    }
    
    public init(id: Int?, trackId: Int?, albumId: Int?, from: String?) {
        self.id = id
        self.trackId = trackId
        self.albumId = albumId
        self.from = from
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var id: Int = 0
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch {
            let idString = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? "0"
            id = Int(idString) ?? 0
        }
        self.id = id
        
        id = 0
        do {
            id = try container.decode(Int.self, forKey: .trackId)
            self.trackId = id
        } catch {
            let idString = try? container.decodeIfPresent(String.self, forKey: .trackId)
            if let g_str = idString, let g_id = Int(g_str) {
                self.trackId = g_id
            } else {
                self.trackId = nil
            }
        }
        
        id = 0
        do {
            id = try container.decode(Int.self, forKey: .albumId)
            self.albumId = id
        } catch {
            let idString = try? container.decodeIfPresent(String.self, forKey: .albumId)
            if let g_str = idString, let g_id = Int(g_str) {
                self.albumId = g_id
            } else {
                self.albumId = nil
            }
        }
    
        self.from = try? container.decodeIfPresent(String.self, forKey: .from)
    }
    
    public func fetchTrack(completion: @escaping (_ result: Result<Track, YMError>) -> Void)
    {
        getTracksByApi(token: accountSecret, trackIds: [trackFullId], positions: false) {
            result in
            do {
                let tracks = try result.get()
                if (tracks.count > 0)
                {
                    completion(.success(tracks[0]))
                } else {
                    completion(.failure(.general(errCode: -1, data: ["description": "Tracks' array is empty"])))
                }
            } catch {
                completion(.failure(.general(errCode: -1, data: ["description": error])))
            }
        }
    }
}
