//
//  Track.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Represents composition track
public class Track: YMBaseObject, Decodable {
    
    //Note: Так как в разных запросах id у артиста может быть как int, так и string [wtf?], то надо переопределять дефолтный декодер
    enum CodingKeys: CodingKey {
        case id
        case realId
        case title
        case available
        case availableForPremiumUsers
        case availableFullWithoutPermission
        case artists
        case albums
        case lyricsAvailable
        case poetryLoverMatches
        case best
        case ogImage
        case type
        case coverUri
        case major
        case durationMs
        case storageDir
        case fileSize
        case substituted
        case matchedTrack
        case normalization
        case r128
        case error
        case canPublish
        case state
        case desiredVisibility
        case filename
        case downloadInfo
        case userInfo
        case metaData
        case regions
        case availableAsRbt
        case contentWarning
        case explicit
        case previewDurationMs
        case version
        case rememberPosition
        case trackSharingFlag
        case backgroundVideoUri
        case shortDescription
        case isSuitableForChildren
    }
    
    ///Track UID
    public let id: String
    ///Track UID (usually equal to id)
    public let realId: String?
    ///Track name
    public let title: String?
    ///Track revision (Additional info about title (remix, feat. etc)
    public let version: String?
    ///Combined track title and its additional info (remix, feat. etc)
    public var trackTitle: String {
        var res: String = ""
        if let g_title = title {
            res += g_title
        }
        if let g_version = version {
            res += " (" + g_version + ")"
        }
        return res
    }
    ///Unique track id. Contains its number and album number or just track number
    public var trackId: String {
        get {
            if albums.count > 0
            {
                return id + ":" + String(albums[0].id ?? -1)
            }
            return id
        }
    }
    ///Track link for sharing
    public var shareUrl: String {
        get {
            return "https://music.yandex.ru/track/" + id
        }
    }
    ///Track available for listening marker
    public let available: Bool?
    ///Track available for listening marker (for users with premium subscription)
    public let availableForPremiumUsers: Bool?
    ///Listening full track without subscription marker
    public let availableFullWithoutPermission: Bool?
    ///Artists of the track
    public let artists: [Artist]
    ///Only artists' names of the track
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
    ///Albums, where is included the track
    public let albums: [Album]
    ///Track lyrics availbale marker
    public let lyricsAvailable: Bool?
    ///Track lyrics data TODO
    public let poetryLoverMatches: [PoetryLoverMatch]?
    ///Included for favorite marker
    public let best: Bool?
    ///Open Graph preview url
    public let ogImage: String?
    ///Track type
    public let type: String?
    ///Track cover image url
    public let coverUri: String?
    ///Major label
    public let major: Major?
    ///Track duration in milliseconds
    public let durationMs: Int
    ///Track duration with different formats. If the duration is less one hour, the format is m:ss, otherwise - H:mm:ss
    public var formattedDuration: String {get {return DateUtil.formattedTrackTime(TimeInterval(durationMs / 1000))}}
    ///Track destiantion folder (server)
    public let storageDir: String?
    ///Track filesize
    public let fileSize: Int?
    ///Substituted track
    public let substituted: Track?
    ///Matched track TODO
    public let matchedTrack: Track?
    ///Normalization parameters for the track
    public let normalization: Normalization?
    ///Normalization parameters fro the track (R128 standard)
    public let r128: NormalizationR128?
    ///Error message
    public let error: String?
    ///Track publisging oportunity marker
    public let canPublish: Bool?
    ///Track state (playable, stopped etc)
    public let state: String?
    ///Track visiblity
    public let desiredVisibility: String?
    ///Track filename
    public let filename: String?
    ///Track download variants info
    public var downloadInfo: [DownloadInfo]?
    ///Returns download variant info with maximum bitrate value
    public var maxQualityDownloadInfo: DownloadInfo? {
        var res: DownloadInfo?
        if let g_downloadInfo = downloadInfo {
            for dInfo in g_downloadInfo {
                if let g_res = res {
                    if dInfo.bitrateInKbps > g_res.bitrateInKbps {
                        res = dInfo
                    }
                } else {
                    res = dInfo
                }
            }
        }
        return res
    }
    ///Returns download variant info with minimum bitrate value
    public var minQualityDownloadInfo: DownloadInfo? {
        var res: DownloadInfo?
        if let g_downloadInfo = downloadInfo {
            for dInfo in g_downloadInfo {
                if let g_res = res {
                    if dInfo.bitrateInKbps < g_res.bitrateInKbps {
                        res = dInfo
                    }
                } else {
                    res = dInfo
                }
            }
        }
        return res
    }
    ///Owner of track (file) info
    public let userInfo: User?
    ///Track metadata info
    public let metaData: MetaData?
    ///Regios TODO
    public let regions: [String]?
    ///TODO
    public let availableAsRbt: Bool?
    ///Track content warning description
    public let contentWarning: String?
    ///Explicit content marker
    public let explicit: Bool?
    ///Track duration if user hasn't active subscription
    public let previewDurationMs: Int?
    ///Track position saving marker
    public let rememberPosition: Bool?
    ///Available track content for sharing
    public let trackSharingFlag: String?
    ///Track video (if available)
    public let backgroundVideoUri: String?
    ///Podcast episode short description
    public let shortDescription: String?
    ///Acceptable for children marker
    public let isSuitableForChildren: Bool?
    
    ///Gets track download info variants (codec, bitrate and etc) without trtack direct download links. Download info will be active for 2 minutes after first direct downloa link fetching
    public func getDownloadInfo( completion: @escaping (_ result: Result<[DownloadInfo], YMError>) -> Void){
        getTrackDownloadInfoByApi(token: accountSecret, trackId: trackId) { result in
            do {
                let downloadInfos = try result.get()
                self.downloadInfo = downloadInfos
                completion(result)
            } catch {
                completion(result)
            }
        }
    }
    
    public func getSupplement(completion: @escaping (_ result: Result<Supplement, YMError>) -> Void) {
        getTrackSupplementByApi(token: accountSecret, trackId: trackId, completion: completion)
    }
    
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
    
    ///Downloads open graph image
    ///- Parameter width: Width of the image
    ///- Parameter height: Height of the image
    ///- Parameter completion: image data response handler
    public func downloadOgImage(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
        if let g_ogImg = ogImage {
            let size = String(width) + "x" + String(height)
            let urlStr = "https://" + g_ogImg.replacingOccurrences(of: "%%", with: size)
            download(fullPath: urlStr, completion: completion)
        }
    }
    
    ///Tries to get track download link by field without dowloading from net
    public func getDownloadLinkSync(codec: TrackCodec = .mp3, bitrate: TrackBitrate = .kbps_192) -> String? {
        if let g_downloadInfo = downloadInfo
        {
            if (g_downloadInfo.count == 0) {
                return nil
            }
            for info in g_downloadInfo {
                if info.codec == codec.codecType && info.bitrateInKbps == bitrate.value, let g_link = info.directLink, info.linkAlive {
                    return g_link
                }
            }
        }
        return nil
    }
    
    ///Parsed direct download links for all download info variants.
    public func fetchAllDownloadlinks() {
        if let _ = downloadInfo {
            for dInfo in downloadInfo! {
                dInfo.getDirectLink { result in
                    #if DEBUG
                    print(result)
                    #endif
                }
            }
        }
    }
    
    ///Gets track download link. Avaiable codecs: mp3, aac. Available bitrates: 64, 128, 192, 320
    public func getDownloadLink(codec: TrackCodec = .mp3, bitrate: TrackBitrate = .kbps_192, completion: @escaping (_ result: Result<String, YMError>) -> Void) {
        if let g_downloadInfo = downloadInfo
        {
            if (g_downloadInfo.count == 0) {
                getDownloadInfo { result in
                    do {
                        let downloadInfos = try result.get()
                        if (downloadInfos.count > 0) {
                            self.getDownloadLink(codec: codec, bitrate: bitrate, completion: completion)
                        } else {
                            var trackInfo = self.trackId
                            if let g_title = self.title {
                                trackInfo += " (" + g_title + ")"
                            }
                            completion(.failure(.trackDownloadInfoNotExists(description: "Not found download info for track " + trackInfo)))
                        }
                    } catch {
                        completion(.failure(.general(errCode: -1, data: ["description": error])))
                    }
                }
                return
            }
            for info in g_downloadInfo {
                if (info.codec == codec.codecType && info.bitrateInKbps == bitrate.value) {
                    info.getDirectLink { result in
                        do {
                            let link = try result.get()
                            completion(.success(link))
                        } catch YMError.trackDownloadLinkDead{
                            //Need to refresh download link by downloading the new info
                            self.downloadInfo = []
                            self.getDownloadLink(codec: codec, bitrate: bitrate, completion: completion)
                        } catch {
                            completion(result)
                        }
                    }
                    return
                }
            }
            let msg: String = "Codec " + codec.codecType + " and bitrate " + bitrate.valueString + " not found"
            #if DEBUG
            print(msg)
            #endif
            completion(.failure(.invalidBitrate(description: msg)))
        } else {
            getDownloadInfo { result in
                do {
                    let downloadInfos = try result.get()
                    if (downloadInfos.count > 0) {
                        self.getDownloadLink(codec: codec, bitrate: bitrate, completion: completion)
                    }
                } catch {
                    let ymError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
                    completion(.failure(ymError))
                }
            }
        }
    }
    
    ///Downloads track. Avaiable codecs: mp3, aac. Available bitrates: 64, 128, 192, 320
    public func downloadTrack(codec: TrackCodec = .mp3, bitrate: TrackBitrate = .kbps_192, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        if let g_downloadInfo = downloadInfo
        {
            if (g_downloadInfo.count == 0) {
                getDownloadInfo { result in
                    do {
                        let downloadInfos = try result.get()
                        if (downloadInfos.count > 0) {
                            self.downloadTrack(codec: codec, bitrate: bitrate, completion: completion)
                        } else {
                            var trackInfo = self.trackId
                            if let g_title = self.title {
                                trackInfo += " (" + g_title + ")"
                            }
                            completion(.failure(.trackDownloadInfoNotExists(description: "Not found download info for track " + trackInfo)))
                        }
                    } catch {
                        completion(.failure(.general(errCode: -1, data: ["description": error])))
                    }
                }
                return
            }
            for info in g_downloadInfo {
                if (info.codec == codec.codecType && info.bitrateInKbps == bitrate.value) {
                    info.downloadTrack(completion: completion)
                    return
                }
            }
            let msg: String = "Codec " + codec.codecType + " and bitrate " + bitrate.valueString + " not found"
            #if DEBUG
            print(msg)
            #endif
            completion(.failure(.invalidBitrate(description: msg)))
        } else {
            getDownloadInfo { result in
                do {
                    let downloadInfos = try result.get()
                    if (downloadInfos.count > 0) {
                        self.downloadTrack(codec: codec, bitrate: bitrate, completion: completion)
                    } else {
                        var trackInfo = self.trackId
                        if let g_title = self.title {
                            trackInfo += " (" + g_title + ")"
                        }
                        completion(.failure(.trackDownloadInfoNotExists(description: "Not found download info for track " + trackInfo)))
                    }
                } catch {
                    completion(.failure(.general(errCode: -1, data: ["description": error])))
                }
            }
        }
    }
    
    public func getSimilarTracks(completion: @escaping (_ result: Result<TracksSimilar, YMError>) -> Void) {
        getSimilarTracksByApi(token: accountSecret, trackId: trackId, completion: completion)
    }
    
    public func like(completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        addLikesTrackByApi(token: accountSecret, userId: accountUidStr, tracksIds: [trackId], completion: completion)
    }
    
    public func removeLike(completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        removeLikesTrackByApi(token: accountSecret, userId: accountUidStr, tracksIds: [trackId], completion: completion)
    }
    
    public func dislike(completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        addDislikesTrackByApi(token: accountSecret, userId: accountUidStr, tracksIds: [trackId], completion: completion)
    }
    
    public func removeDislike(completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        removeDislikesTrackByApi(token: accountSecret, userId: accountUidStr, tracksIds: [trackId], completion: completion)
    }
    
    public init(id: String,
                title: String?,
                available: Bool?,
                artists: [Artist],
                albums: [Album],
                availableForPremiumUsers: Bool?,
                lyricsAvailable: Bool?,
                poetryLoverMatches: [PoetryLoverMatch]?,
                best: Bool?,
                realId: String?,
                ogImg: String?,
                type: String?,
                coverUri: String?,
                major: Major?,
                durationMs: Int,
                storageDir: String?,
                fileSize: Int?,
                substituted: Track?,
                matchedTrack: Track?,
                normalization: Normalization?,
                r128: NormalizationR128?,
                error: String?,
                canPublish: Bool?,
                state: String?,
                desiredVisibility: String?,
                filename: String?,
                userInfo: User?,
                metaData: MetaData?,
                regions: [String]?,
                availableAsRbt: Bool?,
                contentWarning: String?,
                explicit: Bool?,
                previewDurationMs: Int?,
                availableFullWithoutPermission: Bool?,
                version: String?,
                rememberPosition: Bool?,
                trackSharingFlag: String?,
                backgroundVideoUri: String?,
                shortDescription: String?,
                forChildren: Bool?) {
        
        self.id = String(id)
        self.title = title
        self.available = available
        self.artists = artists
        self.albums = albums
        self.availableForPremiumUsers = availableForPremiumUsers
        self.lyricsAvailable = lyricsAvailable
        self.poetryLoverMatches = poetryLoverMatches
        self.best = best
        self.realId = realId
        self.ogImage = ogImg
        self.type = type
        self.coverUri = coverUri
        self.major = major
        self.durationMs = durationMs
        self.storageDir = storageDir
        self.fileSize = fileSize
        self.substituted = substituted
        self.matchedTrack = matchedTrack
        self.normalization = normalization
        self.r128 = r128
        self.error = error
        self.canPublish = canPublish
        self.state = state
        self.desiredVisibility = desiredVisibility
        self.filename = filename
        self.userInfo = userInfo
        self.metaData = metaData
        self.regions = regions
        self.availableAsRbt = availableAsRbt
        self.contentWarning = contentWarning
        self.explicit = explicit
        self.previewDurationMs = previewDurationMs
        self.availableFullWithoutPermission = availableFullWithoutPermission
        self.version = version
        self.rememberPosition = rememberPosition
        self.trackSharingFlag = trackSharingFlag
        self.backgroundVideoUri = backgroundVideoUri
        self.shortDescription = shortDescription
        self.isSuitableForChildren = forChildren

        self.downloadInfo = []
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var id: String = ""
        do {
            id = try container.decode(String.self, forKey: .id)
        } catch {
            let idInt = (try? container.decodeIfPresent(Int.self, forKey: .id)) ?? 0
            id = String(idInt)
        }
        self.id = id
        self.realId = try? container.decodeIfPresent(String.self, forKey: .realId)
        self.title = try? container.decodeIfPresent(String.self, forKey: .title)
        self.version = try? container.decodeIfPresent(String.self, forKey: .version)
        self.contentWarning = try? container.decodeIfPresent(String.self, forKey: .contentWarning)
        self.explicit = try? container.decodeIfPresent(Bool.self, forKey: .explicit)
        self.available = try? container.decodeIfPresent(Bool.self, forKey: .available)
        self.availableForPremiumUsers = try? container.decodeIfPresent(Bool.self, forKey: .availableForPremiumUsers)
        self.availableFullWithoutPermission = try? container.decodeIfPresent(Bool.self, forKey: .availableFullWithoutPermission)
        self.artists = try container.decode([Artist].self, forKey: .artists)
        self.albums = try container.decode([Album].self, forKey: .albums)
        self.lyricsAvailable = try? container.decodeIfPresent(Bool.self, forKey: .lyricsAvailable)
        self.type = try? container.decodeIfPresent(String.self, forKey: .type)
        self.rememberPosition = try? container.decodeIfPresent(Bool.self, forKey: .rememberPosition)
        self.trackSharingFlag = try? container.decodeIfPresent(String.self, forKey: .trackSharingFlag)
        
        self.poetryLoverMatches = try? container.decodeIfPresent([PoetryLoverMatch].self, forKey: .poetryLoverMatches)
        self.best = try? container.decodeIfPresent(Bool.self, forKey: .best)
        self.ogImage = try? container.decodeIfPresent(String.self, forKey: .ogImage)
        self.coverUri = try? container.decodeIfPresent(String.self, forKey: .coverUri)
        self.major = try? container.decodeIfPresent(Major.self, forKey: .major)
        self.storageDir = try? container.decodeIfPresent(String.self, forKey: .storageDir)
        self.fileSize = try? container.decodeIfPresent(Int.self, forKey: .fileSize)
        self.substituted = try? container.decodeIfPresent(Track.self, forKey: .substituted)
        self.matchedTrack = try? container.decodeIfPresent(Track.self, forKey: .matchedTrack)
        self.normalization = try? container.decodeIfPresent(Normalization.self, forKey: .normalization)
        self.r128 = try? container.decodeIfPresent(NormalizationR128.self, forKey: .r128)
        self.error = try? container.decodeIfPresent(String.self, forKey: .error)
        self.canPublish = try? container.decodeIfPresent(Bool.self, forKey: .canPublish)
        self.state = try? container.decodeIfPresent(String.self, forKey: .state)
        self.desiredVisibility = try? container.decodeIfPresent(String.self, forKey: .desiredVisibility)
        self.filename = try? container.decodeIfPresent(String.self, forKey: .filename)
        self.userInfo = try? container.decodeIfPresent(User.self, forKey: .userInfo)
        self.metaData = try? container.decodeIfPresent(MetaData.self, forKey: .metaData)
        self.regions = try? container.decodeIfPresent([String].self, forKey: .regions)
        self.availableAsRbt = try? container.decodeIfPresent(Bool.self, forKey: .availableAsRbt)
        self.previewDurationMs = try? container.decodeIfPresent(Int.self, forKey: .previewDurationMs)
        self.backgroundVideoUri = try? container.decodeIfPresent(String.self, forKey: .backgroundVideoUri)
        self.shortDescription = try? container.decodeIfPresent(String.self, forKey: .shortDescription)
        self.isSuitableForChildren = try? container.decodeIfPresent(Bool.self, forKey: .isSuitableForChildren)
        
        //upd. track unavailable
        do {
            self.durationMs = try container.decode(Int.self, forKey: .durationMs)
        } catch {
            self.durationMs = 0
        }

        self.downloadInfo = []
    }
}
