//
//  Playlist.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///YM Playlist
public class Playlist: YMBaseObject, Decodable {
    
    /*Note:
        Под полями с заглушками понимаются поля, которые доступны у умных плейлистов тогда, когда у сервиса мало
        данных для генерации плейлиста.

        Известные значения `visibility`: `public` - публичный плейлист, `private` - приватный плейлист.

        Известные значения `generated_playlist_type`: `playlistOfTheDay` - Плейлист дня, `recentTracks` - Премьера,
        `neverHeard` - Дежавю, `podcasts` - Подкасты недели, `missedLikes` - Тайник, `origin` - Плейлист с Алисой.

        Известные значения `type`: `missedLikes`, `recentTracks`.*/
    
    ///Playlist owner
    public let owner: User?
    ///Album cover
    public let cover: Cover?
    ///User info of bac-end generated playlist (only for personal playlists)
    public let madeFor: PlaylistFor?
    ///Play days count (only for playlist of a day)
    public let playCounter: PlayCounter?
    ///Playlist absence reason description
    public let playlistAbsence: PlaylistAbsence?
    ///Playlist owner ID
    public let uid: Int?
    ///Playlist ID
    public let kind: Int?
    ///Playlist name
    public var title: String
    ///Playlist tracks count
    public var trackCount: Int?
    ///Playlist tags array
    public let tags: [Tag]?
    ///Data relevance
    public var revision: Int?
    ///Playlist version. Auto increment when edited
    public let snapshot: Int?
    ///Playlsit visibility
    public var visibility: String?
    ///Playlist coauthors marker
    public let collective: Bool?
    ///Playlist partial url (Example: daily)
    public let urlPart: String?
    ///Playlist creation date (ISO 8601)
    public let created: String?
    ///Playlist last modification date (ISO 8601)
    public let modified: String?
    ///Playlist listening availability marker
    public let available: Bool?
    ///Playlist banner appearance marker
    public let isBanner: Bool?
    ///Premier playlist marker TODO
    public let isPremiere: Bool?
    ///Playlist duratiuon in miliseconds
    public let durationMs: Int?
    ///Open Graph preview url
    public let ogImage: String?
    ///Open Graph title
    public let ogTitle: String?
    ///Open Graph description
    public let ogDescription: String?
    /// Playlist image TODO
    public let image: String?
    ///Playlsit cover (without text)
    public let coverWithoutText: Cover?
    ///Playlist contest TODO
    public let contest: Contest?
    ///Playlist background color TODO
    public let backgroundColor: String?
    ///Playlist background image
    public let backgroundImageUrl: String?
    ///Playlist text color TODO
    public let textColor: String?
    ///Event source (Object UID) TODO
    public let idForFrom: String?
    ///Playlist description (dummy)
    public let dummyDescription: String?
    ///Playlist page (dummy)
    public let dummyPageDescription: String?
    ///Playlist dummy cover
    public let dummyCover: Cover?
    ///Playlist dummy cover TODO
    public let dummyRolloverCover: Cover?
    ///Open Graph data
    public let ogData: OpenGraphData?
    ///Brand
    public let branding: PlaylistBrand?
    ///Yandex.Metrika counter UID
    public let metrikaId: Int?
    ///Playlist coauthors accounts IDs
    public let coauthors: [Int]?
    ///Artists top TODO
    public let topArtist: [Artist]?
    ///Recent tracks IDs list
    public let recentTracks: [TrackId]?
    ///Playlist tracks
    public var tracks: [TrackShort]?
    ///Playlist tracks pager
    public let pager: Pager?
    ///Pre-roll, which plays before playlist tracks (Only for personal playlists)
    public let prerolls: [Preroll]?
    ///Playlist likes count
    public let likesCount: Int?
    ///Similar playlists
    public let similarPlaylists: [Playlist]?
    ///Last playlists of current playlist owner
    public let lastOwnerPlaylists: [Playlist]?
    ///Playlist type
    public let generatedPlaylistType: String?
    ///Playlist animated cover url
    public let animatedCoverUri: String?
    ///Playlist 'ever played' marker (only for personal playlists)
    public let everPlayed: Bool?
    ///Playlsit formatted description (Markdown)
    public let description: String?
    ///Playlist raw description
    public let descriptionFormatted: String?
    ///Object UUID
    public let playlistUuid: String?
    ///Playlist name
    public let type: String?
    ///Playlist 'ready' marker TODO
    public let ready: Bool?
    ///TODO
    public let isForFrom: String?//Stock: AnyHashable?
    ///Playlist available regions
    public let regions: [String]?
    ///Playlist description
    public let customWave: CustomWave?

    public var isMine: Bool {
        get {return owner?.uid == accountUid}
    }
    
    ///Playlist creation date (ISO 8601)
    public var createDate: Date? {
        var dt: Date? = nil
        if let g_create = created {
            dt = DateUtil.fromIsoFormat(dateStr: g_create)
        }
        return dt
    }
    
    ///Playlist last modification date (ISO 8601)
    public var modifyDate: Date? {
        var dt: Date? = nil
        if let g_modify = modified {
            dt = DateUtil.fromIsoFormat(dateStr: g_modify)
        }
        return dt
    }
    
    public var playlistId: String {
        if let g_ownerId = owner?.uid
        {
            return String(g_ownerId) + ":" + String(kind ?? 0)
        }
        #if DEBUG
        print("INFO: Unknown owner")
        #endif
        return String(kind ?? 0)
    }
    
    public init(owner: User?,
                cover: Cover?,
                madeFor: PlaylistFor?,
                playCounter: PlayCounter?,
                playlistAbsence: PlaylistAbsence?,
                uid: Int?,
                kind: Int?,
                title: String,
                trackCount: Int?,
                tags: [Tag]?,
                revision: Int?,
                snapshot: Int?,
                visibility: String?,
                collective: Bool?,
                urlPart: String?,
                created: String?,
                modified: String?,
                available: Bool?,
                isBanner: Bool?,
                isPremiere: Bool?,
                durationMs: Int?,
                ogImage: String?,
                ogTitle: String?,
                ogDescription: String?,
                image: String?,
                coverWithoutText: Cover?,
                contest: Contest?,
                backgroundColor: String?,
                backgroundImageUrl: String?,
                textColor: String?,
                idForFrom: String?,
                dummyDescription: String?,
                dummyPageDescription: String?,
                dummyCover: Cover?,
                dummyRolloverCover: Cover?,
                ogData: OpenGraphData?,
                branding: PlaylistBrand?,
                metrikaId: Int?,
                coauthors: [Int]?,
                topArtist: [Artist]?,
                recentTracks: [TrackId]?,
                tracks: [TrackShort],
                pager: Pager?,
                prerolls: [Preroll]?,
                likesCount: Int?,
                similarPlaylists: [Playlist]?,
                lastOwnerPlaylists: [Playlist]?,
                generatedPlaylistType: String?,
                animatedCoverUri: String?,
                everPlayed: Bool?,
                description: String?,
                descriptionFormatted: String?,
                playlistUuid: String?,
                type: String?,
                ready: Bool?,
                isForFrom: String?,
                regions: [String]?,
                customWave: CustomWave?) {
        self.owner = owner
        self.cover = cover
        self.madeFor = madeFor
        self.playCounter = playCounter
        self.playlistAbsence = playlistAbsence

        self.uid = uid
        self.kind = kind
        self.title = title
        self.trackCount = trackCount
        self.revision = revision
        self.snapshot = snapshot
        self.visibility = visibility
        self.collective = collective
        self.urlPart = urlPart
        self.created = created
        self.modified = modified
        self.available = available
        self.isBanner = isBanner
        self.isPremiere = isPremiere
        self.durationMs = durationMs
        self.ogImage = ogImage
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.image = image
        self.coverWithoutText = coverWithoutText
        self.contest = contest
        self.backgroundColor = backgroundColor
        self.backgroundImageUrl = backgroundImageUrl
        self.textColor = textColor
        self.idForFrom = idForFrom
        self.dummyDescription = dummyDescription
        self.dummyPageDescription = dummyPageDescription
        self.dummyCover = dummyCover
        self.dummyRolloverCover = dummyRolloverCover
        self.ogData = ogData
        self.branding = branding
        self.metrikaId = metrikaId
        self.coauthors = coauthors
        self.topArtist = topArtist
        self.recentTracks = recentTracks
        self.tracks = tracks
        self.pager = pager
        self.prerolls = prerolls
        self.likesCount = likesCount
        self.animatedCoverUri = animatedCoverUri
        self.description = description
        self.descriptionFormatted = descriptionFormatted
        self.everPlayed = everPlayed
        self.similarPlaylists = similarPlaylists
        self.lastOwnerPlaylists = lastOwnerPlaylists
        self.generatedPlaylistType = generatedPlaylistType
        self.playlistUuid = playlistUuid
        self.type = type
        self.ready = ready
        self.isForFrom = isForFrom
        self.regions = regions
        self.customWave = customWave
        self.tags = tags
    }
    
    public func getRecommendations(completion: @escaping (_ result: Result<PlaylistRecommendation, YMError>) -> Void) {
        let userId = owner?.uid ?? accountUid
        getPlaylistRecommendationsByApi(token: accountSecret, userId: String(userId), playlistId: String(kind ?? -1), completion: completion)
    }
    
    ///Downloads background image
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadBackgroundImage(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_img = backgroundImageUrl {
            let size = String(width) + "x" + String(height)
            let url = "https://" + g_img.replacingOccurrences(of: "%%", with: size)
            download(fullPath: url, completion: completion)
        }
    }
    
    ///Downloads animated cover
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadAnimatedCover(width: Int = 200, height: Int = 200, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_cover = animatedCoverUri {
            let size = String(width) + "x" + String(height)
            let url = "https://" + g_cover.replacingOccurrences(of: "%%", with: size)
            download(fullPath: url, completion: completion)
        }
    }
    
    ///Downloads open graph image. Use only if cover doesn't exist
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadOgCover(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_cover = ogImage {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_cover.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }
    
    ///Set new name for the playlist
    public func rename(_ name: String, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        if let g_playlistId = kind {
            editPlaylistTitleByApi(token: accountSecret, ownerId: String(owner?.uid ?? accountUid), playlistId: String(g_playlistId), newTitle: name) { result in
                if (try? result.get()) != nil {
                    self.title = name
                }
                completion(result)
            }
        }
    }
    
    ///Set new visbility type for the playlist
    public func setVisibility(_ visibility: PlaylistVisibilityType, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        if let g_playlistId = kind {
            editPlaylistVisibilityByApi(token: accountSecret, ownerId: String(owner?.uid ?? accountUid), playlistId: String(g_playlistId), newVisibility: visibility.rawValue) { result in
                if (try? result.get()) != nil {
                    self.visibility = visibility.rawValue
                }
                completion(result)
            }
        }
    }
    
    ///Remove playlist
    public func remove(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_playlistId = kind {
            deletePlaylistByApi(token: accountSecret, ownerId: String(owner?.uid ?? accountUid), playlistId: String(g_playlistId), completion: completion)
        }
    }
    
    public func like(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_PlaylistUid = kind
        {
            addLikesPlaylistByApi(token: accountSecret, userId: accountUidStr, playlistIds: [String(g_PlaylistUid)], completion: completion)
        }
    }
    
    public func removeLike(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        if let g_PlaylistUid = kind
        {
            removeLikesPlaylistByApi(token: accountSecret, userId: accountUidStr, playlistIds: [String(g_PlaylistUid)], completion: completion)
        }
    }
    
    public func fetchTracks(completion: @escaping (_ result: Result<[Playlist], YMError>) -> Void) {
        if let g_ownerId = owner?.uid, let g_playlistId = kind
        {
            getPlaylistsByApi(token: accountSecret, userId: String(g_ownerId), playlistIds: [String(g_playlistId)]) {
                result in
                if let g_playlists = try? result.get(), g_playlists.count > 0 {
                    self.tracks = g_playlists[0].tracks
                }
                completion(result)
            }
        }
    }
    
    public func insertTrack(trackId: Int, albumId: Int, position: Int = 0, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        let rev = (revision ?? 0) + 1
        insertTrackToPlaylistByApi(token: accountSecret, ownerId: String(owner?.uid ?? -1), playlistId: String(kind ?? -1), trackId: trackId, albumId: albumId, index: position, revision: revision ?? 0) {
            result in
            if let g_playlist = try? result.get() {
                self.revision = rev
                self.tracks = g_playlist.tracks
                self.trackCount = g_playlist.trackCount
            }
            completion(result)
        }
    }
    
    public func insertTracks(tracks: [TrackId], position: Int = 0, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        let rev = (revision ?? 0) + 1
        insertTracksToPlaylistByApi(token: accountSecret, ownerId: String(owner?.uid ?? -1), playlistId: String(kind ?? -1), tracksIds: tracks, index: position, revision: revision ?? 0) {
            result in
            if let g_playlist = try? result.get() {
                self.revision = rev
                self.tracks = g_playlist.tracks
                self.trackCount = g_playlist.trackCount
            }
            completion(result)
        }
    }
    
    public func deleteTracks(from: Int, to: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        let rev = (revision ?? 0) + 1
        deleteTracksFromPlaylistByApi(token: accountSecret, ownerId: String(owner?.uid ?? -1), playlistId: playlistId, from: from, to: to, revision: revision ?? 0) {
            result in
            if let g_playlist = try? result.get() {
                self.revision = rev
                self.tracks = g_playlist.tracks
                self.trackCount = g_playlist.trackCount
            }
            completion(result)
        }
    }
}
