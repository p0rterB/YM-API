//
//  track-short.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Track short metadata
public class TrackShort: Decodable {
    
    enum CodingKeys: CodingKey {
        case id
        case timestamp
        case originalIndex
        case albumId
        case playCount
        case recent
        case chart
        case track
    }
    
    ///Track UID
    public let id: Int
    ///Track info date
    public let timestamp: String
    ///Track index
    public let originalIndex: Int?
    ///Album UID
    public let albumId: String?
    ///Track playing count
    public let playCount: Int?
    ///Track 'recent' status (new)
    public let recent: Bool?
    ///Track chart position
    public let chart: Chart?
    ///Track full info
    public var track: Track?
    ///Unique track id. Contains its number and album number or just track number
    public var trackId: String {
        get {
            if let g_albumID = albumId {
                return String(id) + ":" + g_albumID
            }
            return String(id)
        }
    }

    public init(id: Int, timestamp: String, originalIndex: Int?, albumId: String?, playCount: Int?, recent: Bool?, chart: Chart?, track: Track?) {
        self.id = id
        self.timestamp = timestamp
        self.originalIndex = originalIndex
        self.albumId = albumId
        self.playCount = playCount
        self.recent = recent
        self.chart = chart
        self.track = track
    }
    
    ///Get full track info
    public func fetchTrack(completion: @escaping (_ result: Result<Track, YMError>) -> Void) {
        getTracksByApi(token: accountSecret, trackIds: [trackId], positions: false) {
            result in
            do {
                let tracks = try result.get()
                if (tracks.count > 0)
                {
                    self.track = tracks[0]
                    completion(.success(tracks[0]))
                } else {
                    completion(.failure(.general(errCode: -1, data: ["description": "Tracks' array is empty"])))
                }
            } catch {
                completion(.failure(.general(errCode: -1, data: ["description": error])))
            }
        }
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
        self.timestamp = try container.decode(String.self, forKey: .timestamp)
        self.originalIndex = try? container.decodeIfPresent(Int.self, forKey: .originalIndex)
        var albumId: String?
        do {
            albumId = try container.decodeIfPresent(String.self, forKey: .id)
        } catch {
            let idInt = (try? container.decodeIfPresent(Int.self, forKey: .id)) ?? 0
            albumId = String(idInt)
        }
        self.albumId = albumId
        self.playCount = try? container.decodeIfPresent(Int.self, forKey: .playCount)
        self.recent = try? container.decodeIfPresent(Bool.self, forKey: .recent)
        self.chart = try? container.decodeIfPresent(Chart.self, forKey: .chart)
        self.track = try? container.decodeIfPresent(Track.self, forKey: .chart)
    }
}
