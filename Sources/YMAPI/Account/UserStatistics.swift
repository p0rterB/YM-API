//
//  UserStatistics.swift
//  YM-API
//
//  Created by Developer on 12.05.2022.
//

import Foundation

///Represensents user account statistics info
public class UserStatistics: YMBaseObject, Decodable {
    
    enum CodingKeys: CodingKey {
        case likedUsers
        case likedByUsers
        case hasTracks
        case likedArtists
        case likedAlbums
        case ugcTracks
    }
    
    ///Likes for other users count
    public let likedUsers: Int
    ///Likes from another users for this account
    public let likedByUsers: Int
    ///User account has tracks (Uploaded or user is track author)
    public let hasTracks: Bool
    ///Likes for artists count
    public let likedArtists: Int
    ///Likes for albums count
    public let likedAlbums: Int
    ///User-generated-content (tracks)
    public let ugcTracks: Int
    
    public init(likeForUsers: Int, likeFromUsers: Int, hasTracks: Bool, likeForArtists: Int, likeForAlbums: Int, ugcTr: Int)
    {
        likedUsers = likeForUsers
        likedByUsers = likeFromUsers
        self.hasTracks = hasTracks
        likedArtists = likeForArtists
        likedAlbums = likeForAlbums
        ugcTracks = ugcTr
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.likedUsers = (try? container.decodeIfPresent(Int.self, forKey: .likedUsers)) ?? 0
        self.likedByUsers = (try? container.decodeIfPresent(Int.self, forKey: .likedByUsers)) ?? 0
        self.hasTracks = (try? container.decodeIfPresent(Bool.self, forKey: .hasTracks)) ?? false
        self.likedArtists = (try? container.decodeIfPresent(Int.self, forKey: .likedArtists)) ?? 0
        self.likedAlbums = (try? container.decodeIfPresent(Int.self, forKey: .likedAlbums)) ?? 0
        self.ugcTracks = (try? container.decodeIfPresent(Int.self, forKey: .ugcTracks)) ?? 0
    }
}
