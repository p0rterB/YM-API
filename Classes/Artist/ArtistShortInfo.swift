//
//  BriefInfo.swift
//  yandexMusic-iOS
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents artist short info
public class ArtistShortInfo: Decodable {
    
    ///Artist
    public let artist: Artist?
    ///Albums
    public let albums: [Album]
    ///Playlists
    public let playlists: [Playlist]
    ///Set of albums 'also' category
    public let alsoAlbums: [Album]
    ///Last released albums IDs
    public let lastReleaseIds: [Int]
    ///Last released albums
    public let lastReleases: [Album]
    ///Popular tracks
    public let popularTracks: [Track]
    ///Similar artists
    public let similarArtists: [Artist]
    ///All covers
    public let allCovers: [Cover]
    ///Concerts data
    public let concerts: [String]
    ///Videos
    public let videos: [Video]
    ///Vinyls
    public let vinyls: [Vinyl]
    ///Promotion marker
    public let hasPromotions: Bool
    ///Playlists IDs
    public let playlistIds: [PlaylistId]
    ///Chart tracks
    public let tracksInChart: [Chart]?
    
    public init(artist: Artist?,
                albums: [Album],
                playlists: [Playlist],
                alsoAlbums: [Album],
                lastReleaseIds: [Int],
                lastReleases: [Album],
                popularTracks: [Track],
                similarArtists: [Artist],
                allCovers: [Cover],
                concerts: [String],
                videos: [Video],
                vinyls: [Vinyl],
                hasPromotions: Bool,
                playlistIds: [PlaylistId],
                tracksInChart: [Chart]?) {
        self.artist = artist
        self.albums = albums
        self.playlists = playlists
        self.alsoAlbums = alsoAlbums
        self.lastReleaseIds = lastReleaseIds
        self.lastReleases = lastReleases
        self.popularTracks = popularTracks
        self.similarArtists = similarArtists
        self.allCovers = allCovers
        self.concerts = concerts
        self.videos = videos
        self.vinyls = vinyls
        self.hasPromotions = hasPromotions
        self.playlistIds = playlistIds

        self.tracksInChart = tracksInChart
    }
}
