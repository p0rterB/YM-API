//
//  LikeObjectId.swift
//  YM-API
//
//  Created by Developer on 26.07.2021.
//
///Represents universal like object ID info
public class LikeObject: Decodable {
    ///Object ID
    public let id: String?
    ///Album ID (for track object)
    public let albumId: String?
    ///Liked artist
    public let artist: Artist?
    ///Liked playlist
    public let playlist: Playlist?
    ///Like timestamp
    public let timestamp: String?
    
    
    enum CodingKeys: CodingKey {
        case id
        case albumId
        case artist
        case playlist
        case timestamp
    }
    
    public init(id: String?, albumId: String?, artist: Artist?, playlist: Playlist?, timestamp: String?) {
        self.id = id
        self.albumId = albumId
        self.artist = artist
        self.playlist = playlist
        self.timestamp = timestamp
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var id: String? = nil
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch {
            let idInt = try? container.decodeIfPresent(Int.self, forKey: .id)
            if let g_id = idInt {
                id = String(g_id)
            }
        }
        self.id = id
        self.albumId = try? container.decodeIfPresent(String.self, forKey: .albumId)
        self.artist = try? container.decodeIfPresent(Artist.self, forKey: .artist)
        self.playlist = try? container.decodeIfPresent(Playlist.self, forKey: .playlist)
        self.timestamp = try? container.decodeIfPresent(String.self, forKey: .timestamp)
    }
}
