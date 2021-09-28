//
//  Search.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Represents back-end search data response
public class Search: Decodable {

    ///Search request ID
    public let searchRequestId: String
    ///Reqeust payload - search text
    public let text: String
    ///Best found result
    public let best: Best?
    ///Found albums
    public let albums: SearchResultAlbums?
    ///Found artists
    public let artists: SearchResultArtists?
    ///Found playlists
    public let playlists: SearchResultPlaylists?
    ///Found tracks
    public let tracks: SearchResultTracks?
    ///Found videos
    public let videos: SearchResultVideos?
    ///Found users
    public let users: SearchResultUsers?
    ///Found podcasts
    public let podcasts: SearchResultPodcasts?
    ///Found podcast episodes
    public let podcastEpisodes: SearchResultPodcasts?
    ///Search type
    public let type: String?
    ///Current page index
    public var page: Int?
    ///Found items count on page
    public let perPage: Int?
    ///Search text with automatic correction
    public let misspellResult: String?
    ///Stock search text
    public let misspellOriginal: String?
    ///Search text correction marker
    public let misspellCorrected: Bool?
    ///Search text correction disabled status marker
    public let nocorrect: Bool?

    public init(searchReqID: String, text: String, best: Best?, albums: SearchResultAlbums?, artists: SearchResultArtists?, playlists: SearchResultPlaylists?, tracks: SearchResultTracks?, videos: SearchResultVideos?, users: SearchResultUsers?, podcasts: SearchResultPodcasts?, podcastEpisodes: SearchResultPodcasts?, type: String?, page: Int?, perPage: Int?, misspellResult: String?, misspellOriginal: String?, misspellCorrected: Bool?, nocorrect: Bool?) {
        self.searchRequestId = searchReqID
        self.text = text
        self.best = best
        self.albums = albums
        self.artists = artists
        self.playlists = playlists
        self.tracks = tracks
        self.videos = videos
        self.users = users

        self.podcasts = podcasts
        self.podcastEpisodes = podcastEpisodes
        self.type = type
        self.page = page
        self.perPage = perPage
        self.misspellResult = misspellResult
        self.misspellOriginal = misspellOriginal
        self.misspellCorrected = misspellCorrected
        self.nocorrect = nocorrect

        
    }
    
    ///Get search page
    func getPage(at index: Int, includeBestPlaylists: Bool, completion: @escaping (_ result: Result<Search, YMError>) -> Void) {
        searchByApi(token: accountSecret, text: text, noCorrect: nocorrect ?? false, type: type ?? SearchType.all.stringType, page: index, includeBestPlaylists: includeBestPlaylists, completion: completion)
    }
    
    ///Get next page of search
    func nextPage(includeBestPlaylists: Bool, completion: @escaping (_ result: Result<Search, YMError>) -> Void) {
        if let g_page = page {
            getPage(at: g_page + 1, includeBestPlaylists: includeBestPlaylists, completion: completion)
        }
    }
    
    ///Get previous page of search
    func prevPage(includeBestPlaylists: Bool, completion: @escaping (_ result: Result<Search, YMError>) -> Void){
        if let g_page = page {
            if (g_page > 0) {
                getPage(at: g_page - 1, includeBestPlaylists: includeBestPlaylists, completion: completion)
                return
            }
            completion(.success(self))
        }
    }
}
