//
//  Podcast.swift
//  YM-API
//
//  Created by Developer on 26.08.2021.
//

import Foundation

///Represents podcast
public class Podcast: YMBaseObject, Decodable {

    enum CodingKeys: CodingKey {
        case id
        case storageDir
        case artists
        case coverUri
        case trackCount
        case likesCount
        case genre
        case available
        case contentWarning
        case availableForPremiumUsers
        case type
        case title
        case availableRegions
        case labels
    }
    
    ///Podacst UID
    public let id: Int
    ///Track destiantion folder (server)
    public let storageDir: String?
    ///Artists of the podcast. Usually is empty
    public let artists: [Artist]
    ///Only artists' names of the podcast
    public var artistsName: [String] {
        get
        {
            var res: [String] = []
            for artist in artists {
                let name = artist.artistName
                if (!name.isEmpty) {
                    res.append(name)
                }
            }
            return res
        }
    }
    ///Podcast cover image url
    public let coverUri: String?
    ///Podcast inner tracks count
    public let trackCount: Int
    ///Podcast likes count
    public let likesCount: Int
    ///Podcast genre
    public let genre: String
    ///Podcast available for listening marker
    public let available: Bool?
    ///Podcast content warning description
    public let contentWarning: String?
    ///Track available for listening marker (for users with premium subscription)
    public let availableForPremiumUsers: Bool?
    ///YM Object type (=podcast)
    public let type: String
    ///Podcast name
    public let title: String?
    ///Podcast available regions list for listening
    public let availableRegions: [String]
    ///Podcast labels list
    public let labels: [String]
    
    ///Downloads cover image
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadCover(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_coverUri = coverUri
        {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_coverUri.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }
    
    public init(id: Int,
                title: String?,
                storageDir: String,
                available: Bool?,
                artists: [Artist],
                availableForPremiumUsers: Bool?,
                type: String,
                coverUri: String?,
                trackCount: Int,
                likesCount: Int,
                genre: String,
                contentWarning: String?,
                availableRegions: [String],
                labels: [String]) {
        
        self.id = id
        self.title = title
        self.available = available
        self.artists = artists
        self.availableForPremiumUsers = availableForPremiumUsers
        self.type = type
        self.coverUri = coverUri
        self.trackCount = trackCount
        self.likesCount = likesCount
        self.genre = genre
        self.storageDir = storageDir
        self.contentWarning = contentWarning
        self.availableRegions = availableRegions
        self.labels = labels
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var id: Int = -1
        do {
            id = try container.decode(Int.self, forKey: .id)
        } catch {
            let idStr = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? "-1"
            id = Int(idStr) ?? -1
        }
        self.id = id
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.available = try? container.decodeIfPresent(Bool.self, forKey: .available)
        self.artists = try container.decode([Artist].self, forKey: .artists)
        self.availableForPremiumUsers = try? container.decodeIfPresent(Bool.self, forKey: .availableForPremiumUsers)
        self.type = try container.decode(String.self, forKey: .type)
        self.coverUri = try? container.decodeIfPresent(String.self, forKey: .coverUri)
        self.trackCount = try container.decode(Int.self, forKey: .trackCount)
        self.likesCount = try container.decode(Int.self, forKey: .likesCount)
        self.genre = try container.decode(String.self, forKey: .genre)
        self.storageDir = try container.decode(String.self, forKey: .storageDir)
        self.contentWarning = try? container.decodeIfPresent(String.self, forKey: .contentWarning)
        self.availableRegions = try container.decode([String].self, forKey: .availableRegions)
        self.labels = try container.decode([String].self, forKey: .labels)
    }
}
