//
//  Album.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents album
public class Album: YMBaseObject, Decodable {
    //Note: Известные типы альбома: `single` - сингл, `compilation` - сборник. Известные предупреждения о содержимом: `explicit` - ненормативная лексика. Известные ошибки: `not-found` - альбом с таким ID не существует. Известные значения поля `meta_type`: `music`.
    
    enum CodingKeys: CodingKey {
        case id
        case error
        case title
        case trackCount
        case artists
        case labels
        case available
        case availableForPremiumUsers
        case version
        case coverUri
        case contentWarning
        case originalReleaseYear
        case genre
        case textColor
        case shortDescription
        case description
        case isPremiere
        case isBanner
        case metaType
        case storageDir
        case ogImage
        case buy
        case recent
        case veryImportant
        case availableForMobile
        case availablePartially
        case bests
        case duplicates
        case prerolls
        case volumes
        case year
        case releaseDate
        case type
        case trackPosition
        case regions
        case availableAsRbt
        case lyricsAvailable
        case rememberPosition
        case albums
        case durationMs
        case explicit
        case startDate
        case likesCount
        case deprecation
        case availableRegions
    }
    
    ///Album ID
    public let id: Int?
    ///Album getting error description
    public let error: String?
    ///Album name
    public let title: String?
    ///Album's tracks count
    public let trackCount: Int?
    ///Album artists
    public let artists: [Artist]?
    ///Album labels
    public let labels: [Label]?//Union(String, Label)
    ///Album availability marker
    public let available: Bool?
    ///Only for premium users availability marker
    public let availableForPremiumUsers: Bool?
    ///Album additional info
    public let version: String?
    ///Album cover image url
    public let coverUri: String?
    ///Album content warning (explicit)
    public let contentWarning: String?
    ///No Description TODO
    public let originalReleaseYear: String?//NONE
    ///Music genre
    public let genre: String?
    ///Description text color
    public let textColor: String?
    ///Album short description
    public let shortDescription: String?
    ///Album full description
    public let description: String?
    ///Is album new (premier) marker
    public let isPremiere: Bool?
    ///Presents as a banner marker
    public let isBanner: Bool?
    ///Album content type
    public let metaType: String?
    ///Album data back-end source storage path TODO
    public let storageDir: String?
    ///Album Open Graph preview image url
    public let ogImage: String?
    ///No description TODO
    public let buy: [String]?
    ///Is album new (recent) marker
    public let recent: Bool?
    ///Users popular marker
    public let veryImportant: Bool?
    ///Available from mobile app marker
    public let availableForMobile: Bool?
    ///Available for users without subscription marker
    public let availablePartially: Bool?
    ///Best albums tracks IDs
    public let bests: [Int]?
    ///Albums duplicates
    public let duplicates: [Album]?
    ///Prerolls TODO
    public let prerolls: [String]?
    ///Splitted by volumes tracks
    public let volumes: [[Track]]?
    ///Album release year
    public let year: Int?
    ///Album release date (ISO 8601 format)
    public let releaseDate: String?
    ///Album type
    public let type: String?
    ///Track position (When reqeusts parent album from track context)
    public let trackPosition: TrackPosition?
    ///No description TODO
    public let regions: [String]?
    ///TODO
    public let availableAsRbt: Bool?
    ///Lyrics available marker
    public let lyricsAvailable: Bool?
    ///Remember track number marker
    public let rememberPosition: Bool?
    ///Albums TODO
    public let albums: [Album]?
    ///Album play duration in miliseconds
    public let durationMs: [Int]?
    ///Explicit marker
    public let explicit: Bool?
    ///Start date (ISO 8601 format) TODO
    public let startDate: String?
    ///Album likes count
    public let likesCount: Int?
    ///TODO
    public let deprecation: Deprecation?
    ///Album available regions
    public let availableRegions: [String]?
    
    public var artistsName: [String] {
        get {
            var names: [String] = []
            if let g_artists = artists {
                for artist in g_artists {
                    if let g_name = artist.name, g_name.compare("") != .orderedSame {
                        names.append(g_name)
                    }
                }
            }
            return names
        }
    }
    
    public init(id: Int?,
                error: String?,
                title: String?,
                trackCount: Int?,
                artists: [Artist]?,
                labels: [Label]?,
                available: Bool?,
                availableForPremiumUsers: Bool?,
                version: String?,
                coverUri: String?,
                contentWarning: String?,
                originalReleaseYear: String?,
                genre: String?,
                textColor: String?,
                shortDescription: String?,
                description: String?,
                isPremiere: Bool?,
                isBanner: Bool?,
                metaType: String?,
                storageDir: String?,
                ogImage: String?,
                buy: [String]?,
                recent: Bool?,
                veryImportant: Bool?,
                availableForMobile: Bool?,
                availablePartially: Bool?,
                bests: [Int]?,
                duplicates: [Album]?,
                prerolls: [String]?,
                volumes: [[Track]]?,
                year: Int?,
                releaseDate: String?,
                type: String?,
                trackPosition: TrackPosition?,
                regions: [String]?,
                availableAsRbt: Bool?,
                lyricsAvailable: Bool?,
                rememberPosition: Bool?,
                albums: [Album]?,
                durationMs: [Int]?,
                explicit: Bool?,
                startDate: String?,
                likesCount: Int?,
                deprecation: Deprecation?,
                availableRegions: [String]?) {
        self.id = id
        self.error = error
        self.title = title
        self.trackCount = trackCount
        self.artists = artists
        self.labels = labels
        self.availableForPremiumUsers = availableForPremiumUsers
        self.available = available
        self.version = version
        self.coverUri = coverUri
        self.genre = genre
        self.textColor = textColor
        self.shortDescription = shortDescription
        self.description = description
        self.isPremiere = isPremiere
        self.isBanner = isBanner
        self.metaType = metaType
        self.year = year
        self.releaseDate = releaseDate
        self.bests = bests
        self.duplicates = duplicates
        self.prerolls = prerolls
        self.volumes = volumes
        self.storageDir = storageDir
        self.ogImage = ogImage
        self.buy = buy
        self.recent = recent
        self.veryImportant = veryImportant
        self.availableForMobile = availableForMobile
        self.availablePartially = availablePartially
        self.type = type
        self.trackPosition = trackPosition
        self.regions = regions
        self.originalReleaseYear = originalReleaseYear
        self.contentWarning = contentWarning
        self.availableAsRbt = availableAsRbt
        self.lyricsAvailable = lyricsAvailable
        self.rememberPosition = rememberPosition
        self.albums = albums
        self.durationMs = durationMs
        self.explicit = explicit
        self.startDate = startDate
        self.likesCount = likesCount
        self.deprecation = deprecation
        self.availableRegions = availableRegions
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decodeIfPresent(Int.self, forKey: .id)
        self.error = try? container.decodeIfPresent(String.self, forKey: .error)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.trackCount = try? container.decodeIfPresent(Int.self, forKey: .trackCount)
        self.artists = try? container.decodeIfPresent([Artist].self, forKey: .artists)
        var labels: [Label] = []
        do {
            labels = try container.decodeIfPresent([Label].self, forKey: .labels) ?? []
        } catch {
            let stringLabels = (try? container.decodeIfPresent([String].self, forKey: .labels)) ?? []
            for label in stringLabels {
                labels.append(Label(id: -1, name: label))
            }
        }
        self.labels = labels
        self.available = try? container.decodeIfPresent(Bool.self, forKey: .available)
        self.availableForPremiumUsers = try? container.decodeIfPresent(Bool.self, forKey: .availableForPremiumUsers)
        self.version = try? container.decodeIfPresent(String.self, forKey: .version)
        self.coverUri = try? container.decodeIfPresent(String.self, forKey: .coverUri)
        self.contentWarning = try? container.decodeIfPresent(String.self, forKey: .contentWarning)
        self.originalReleaseYear = try? container.decodeIfPresent(String.self, forKey: .originalReleaseYear)
        self.genre = try? container.decodeIfPresent(String.self, forKey: .genre)
        self.textColor = try? container.decodeIfPresent(String.self, forKey: .textColor)
        self.shortDescription = try? container.decodeIfPresent(String.self, forKey: .shortDescription)
        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
        self.isPremiere = try? container.decodeIfPresent(Bool.self, forKey: .isPremiere)
        self.isBanner = try? container.decodeIfPresent(Bool.self, forKey: .isBanner)
        self.metaType = try? container.decodeIfPresent(String.self, forKey: .metaType)
        self.storageDir = try? container.decodeIfPresent(String.self, forKey: .storageDir)
        self.ogImage = try? container.decodeIfPresent(String.self, forKey: .ogImage)
        self.buy = try? container.decodeIfPresent([String].self, forKey: .buy)
        self.recent = try? container.decodeIfPresent(Bool.self, forKey: .recent)
        self.veryImportant = try? container.decodeIfPresent(Bool.self, forKey: .veryImportant)
        self.availableForMobile = try? container.decodeIfPresent(Bool.self, forKey: .availableForMobile)
        self.availablePartially = try? container.decodeIfPresent(Bool.self, forKey: .availablePartially)
        self.bests = try? container.decodeIfPresent([Int].self, forKey: .bests)
        self.duplicates = try? container.decodeIfPresent([Album].self, forKey: .duplicates)
        self.prerolls = try? container.decodeIfPresent([String].self, forKey: .prerolls)
        self.volumes = try? container.decodeIfPresent([[Track]].self, forKey: .volumes)
        self.year = try? container.decodeIfPresent(Int.self, forKey: .year)
        self.releaseDate = try? container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.trackPosition = try? container.decodeIfPresent(TrackPosition.self, forKey: .trackPosition)
        self.regions = try? container.decodeIfPresent([String].self, forKey: .regions)
        self.availableAsRbt = try? container.decodeIfPresent(Bool.self, forKey: .availableAsRbt)
        self.lyricsAvailable = try? container.decodeIfPresent(Bool.self, forKey: .lyricsAvailable)
        self.rememberPosition = try? container.decodeIfPresent(Bool.self, forKey: .rememberPosition)
        self.albums = try? container.decodeIfPresent([Album].self, forKey: .albums)
        self.durationMs = try? container.decodeIfPresent([Int].self, forKey: .durationMs)
        self.explicit = try? container.decodeIfPresent(Bool.self, forKey: .explicit)
        self.startDate = try? container.decodeIfPresent(String.self, forKey: .startDate)
        self.likesCount = try? container.decodeIfPresent(Int.self, forKey: .likesCount)
        self.deprecation = try? container.decodeIfPresent(Deprecation.self, forKey: .deprecation)
        self.availableRegions = try? container.decodeIfPresent([String].self, forKey: .availableRegions)
    }
    
    public func withTracks(completion: @escaping (Result<Album, YMError>) -> Void) {
        if let g_id = id
        {
            getAlbumWithTracksByApi(token: accountSecret, albumId: String(g_id), completion: completion)
        }
    }
    
    ///Downloads album cover image
    ///- Parameter width: Width of the cover image
    ///- Parameter height: Height of the cover image
    ///- Parameter completion: Album avatar image data response handler
    public func downloadCoverImg(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_cover = coverUri {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_cover.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }

    ///Downloads album open graph image
    ///- Parameter width: Width of the open graph image
    ///- Parameter height: Height of the open graph image
    ///- Parameter completion: Album open graph image data response handler
    public func downloadOgImage(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_ogImg = ogImage {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_ogImg.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }
    
    public func like(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_albumId = id
        {
            addLikesAlbumByApi(token: accountSecret, userId: accountUidStr, albumIds: [String(g_albumId)], completion: completion)
        }
    }
    
    public func removeLike(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_albumId = id
        {
            removeLikesAlbumByApi(token: accountSecret, userId: accountUidStr, albumIds: [String(g_albumId)], completion: completion)
        }
    }
}
