//
//  Client.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

var xYmClient = YMConstants.xYmClient
var xTokenClientId = YMConstants.xTokenClientId
var xTokenClientSecret = YMConstants.xTokenClientSecret
var clientId = YMConstants.clientId
var clientSecret = YMConstants.clientSecret

var accountUidStr: String {
    get {
        return String(accountUid)
    }
}

var accountUid: Int {
    get {
        return YMClient.shared.userID ?? -1
    }
}

var accountSecret: String {
    get {
        return YMClient.shared.token
    }
}

var passportSecret: String {
    get {
        return YMClient.shared.xToken
    }
}

///Represents YM API functions wrapper for easier access
public class YMClient {
    
    ///Version of YM-API module
    public static let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
    ///YM-API module build number
    public static let buildNum: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    ///Yandex Music client instance
    public static var shared: YMClient!
    
    ///Authorization token
    var token: String
    ///Passport Yandex access token
    var xToken: String
    ///User ID
    fileprivate var userID: Int?
    ///User ID
    public var accountUid: Int {
        get {
            return userID ?? -1
        }
    }
    ///API responses language
    var apiLang: ApiLanguage
    ///Device info
    var device: YMDevice
    
    ///Authorization marker
    var authed: Bool
    {
        get {return token.compare("") != .orderedSame && userID != nil && userID != -1}
    }
    
    init() {
        token = ""
        xToken = ""
        userID = nil
        apiLang = ApiLanguage.en
        device = YMDevice(os: "", osVer: "", manufacturer: "", name: "", platform: "", model: "", clid: "", deviceId: "", uuid: "")
    }
    
    init(token: String, xToken: String, uid: Int?, apiLang: ApiLanguage, device: YMDevice)
    {
        self.token = token
        self.xToken = xToken
        self.userID = uid
        self.apiLang = apiLang
        self.device = device
    }
    
    ///Initialize client with authorized session
    ///- Parameter device: Device info
    ///- Parameter lang: API responses language
    ///- Parameter ymClientId: Yandex Music client bundle name
    ///- Parameter appClientId: Yandex Music client application ID
    ///- Parameter appClientSecret: Yandex Music client application secret
    ///- Parameter uid: User ID
    ///- Parameter token: User authorization token
    ///- Parameter xToken: Passport Yandex access token
    ///- Returns: YMClient instance
    public static func initialize(device: YMDevice, lang: ApiLanguage, ymClientId: String = YMConstants.xYmClient, appClientId: String = YMConstants.clientId, appClientSecret: String = YMConstants.clientSecret, uid: Int, token: String, xToken: String) -> YMClient{
        if (ymClientId.compare("") != .orderedSame)
        {
            xYmClient = ymClientId
        }
        if (appClientId.compare("") != .orderedSame)
        {
            clientId = appClientId
        }
        if (appClientSecret.compare("") != .orderedSame)
        {
            clientSecret = appClientSecret
        }
        let client = YMClient(token: token, xToken: xToken, uid: uid, apiLang: lang, device: device)
        shared = client
        #if DEBUG
        print("Client initialized and ready for work")
        #endif
        return shared
    }

    ///Initialize client without active session (first launch, for example)
    ///- Parameter device: Device info
    ///- Parameter lang: API responses language
    ///- Parameter ymClientId: Yandex Music client bundle name
    ///- Parameter appClientId: Yandex Music client application ID
    ///- Parameter appClientSecret: Yandex Music client application secret
    ///- Returns: YMClient instance
    public static func initialize(device: YMDevice, lang: ApiLanguage, ymClientId: String = YMConstants.xYmClient, appClientId: String = YMConstants.clientId, appClientSecret: String = YMConstants.clientSecret) -> YMClient {
        return initialize(device: device, lang: lang, ymClientId: ymClientId, appClientId: appClientId, appClientSecret: appClientSecret, uid: -1, token: "", xToken: "")
    }
    
    ///Send raw request and trying to parse response
    ///- Parameter basePath: API base URL
    ///- Parameter payloadPath: API rest url
    ///- Parameter authHeaderValue: Request authorization header value (token data)
    ///- Parameter headers: Request headers
    ///- Parameter method: Request method
    ///- Parameter bodyData: Request body data (for POST request)
    ///- Parameter completion: Parsed response data handler
    public func sendRawDataRequest(basePath: String = YMConstants.apiBasePath, payloadPath: String, authHeaderValue: String?, headers: [String: String], method: String, bodyData: Data?, completion: @escaping (_ result: Result<YMResponse, YMError>) -> Void) {
        guard let req = buildRequest(basePath: basePath, payloadPath: payloadPath, authHeaderValue: authHeaderValue, headers: headers, method: method, bodyData: bodyData) else {
            completion(.failure(.badRequest(errCode: -1, description: "Error during building request")))
            return
        }
        requestYMResponse(req, completion: completion)
    }
    ///Send raw request with representing response as a json object
    ///- Parameter basePath: API base URL
    ///- Parameter payloadPath: API rest url
    ///- Parameter authHeaderValue: Request authorization header value (token data)
    ///- Parameter headers: Request headers
    ///- Parameter method: Request method
    ///- Parameter bodyData: Request body data (for POST request)
    ///- Parameter completion: Key-value dictionary response data handler
    public func sendRawDataRequest(basePath: String = YMConstants.apiBasePath, payloadPath: String, authHeaderValue: String?, headers: [String: String], method: String, bodyData: Data?, completion: @escaping (_ result: Result<[String: Any], YMError>) -> Void) {
        guard let req = buildRequest(basePath: basePath, payloadPath: payloadPath, authHeaderValue: authHeaderValue, headers: headers, method: method, bodyData: bodyData) else {
            completion(.failure(.badRequest(errCode: -1, description: "Error during building request")))
            return
        }
        requestJson(req, completion: completion)
    }
    ///Send raw request without the parsing of response data
    ///- Parameter basePath: API base URL
    ///- Parameter payloadPath: API rest url
    ///- Parameter authHeaderValue: Request authorization header value (token data)
    ///- Parameter headers: Request headers
    ///- Parameter method: Request method
    ///- Parameter bodyData: Request body data (for POST request)
    ///- Parameter completion: Raw response data handler
    public func sendRawDataRequest(basePath: String = YMConstants.apiBasePath, payloadPath: String, authHeaderValue: String?, headers: [String: String], method: String, bodyData: Data?, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
        guard let req = buildRequest(basePath: basePath, payloadPath: payloadPath, authHeaderValue: authHeaderValue, headers: headers, method: method, bodyData: bodyData) else {
            completion(.failure(.badRequest(errCode: -1, description: "Error during building request")))
            return
        }
        requestData(req, completion: completion)
    }
    ///Initialize authorization session URL string (with new Yandex authorization system)
    ///- Parameter amPassportVersion: Authorization module version
    ///- Parameter appId: Application identifier
    ///- Parameter appVersion: Application version
    ///- Returns Key-Value object, where key is url string and value is url request
    public func generateInitAuthSessionRequest(amPassportVersion: String = YMConstants.amPassportVersionName, appId: String = YMConstants.appBundleId, appVersion: String = version) -> (String, URLRequest?) {
        let apiFuncTarget = ApiFunction.auth_init_session(lang: apiLang, appId: appId, uuid: device.uuid, amVersionaName: amPassportVersion, appVersionName: appVersion, manufacturer: device.manufacturer, deviceId: device.deviceId, deviceName: device.name, platform: device.apiPlatform, model: device.model)
        let pathEncoded = apiFuncTarget.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = apiFuncTarget.baseURL + pathEncoded
        let req = buildRequest(for: apiFuncTarget)
        let res = (urlStr, req)
    
        return res
    }
    ///Generate X token from successfully passed challenge track ID
    ///- Parameter trackId: Track ID from successfully passed challenge
    ///- Parameter appId: Application identifier
    ///- Parameter appVersion: Application version
    ///- Parameter amAppVersionName: AM authorization challenge client version
    ///- Parameter completion: Authorization status response handler
    public func generateXTokenFromChallengeTrackId(trackId: String, yaClientCookie: String, appId: String = YMConstants.appBundleId, appVersion: String = version, amAppVersionName: String = YMConstants.amPassportVersionName, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
        generateXTokenByAmApi(xClientId: xTokenClientId, xClientSecret: xTokenClientSecret, yaClientCookie: yaClientCookie, trackId: trackId, manufacturer: device.manufacturer, model: device.model, platform: device.platform, amVersionName: amAppVersionName, appId: appId, appVersionName: appVersion, deviceId: device.deviceId, completion: completion)
    }
    ///Generate Yandex Music token from authorization X Token (with new Yandex authorization system)
    ///- Parameter xToken: X Token from previous step of authorization
    ///- Parameter appId: Application identifier
    ///- Parameter appVersion: Application version
    ///- Parameter amAppVersionName: AM authorization challenge client version
    ///- Parameter completion: Authorization status response handler
    public func generateYMTokenFromXToken(xToken: String, appId: String = YMConstants.appBundleId, appVersion: String = version, amAppVersionName: String = YMConstants.amPassportVersionName, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
        generateYMTokenByApi(xToken: xToken, ymClientId: clientId, ymClientSecret: clientSecret, appId: appId, amVersionName: amAppVersionName, appVersionName: appVersion, manufacturer: device.manufacturer, deviceId: device.deviceId, platform: device.platform) { result in
            do {
                let dict = try result.get()
                YMClient.shared.token = dict[.access_token] ?? ""
                YMClient.shared.userID = Int(dict[.uid] ?? "-1") ?? -1
            } catch {}
            completion(result)
        }
    }
    ///Get account info
    ///- Parameter completion: Parsed account info response handler
    public func getAccountStatus(completion: @escaping (_ result: Result<Status, YMError>) -> Void)
    {
        getAccountStatusByApi(token: accountSecret, completion: completion)
    }
    ///Get user info by defined UID. Can be executed without active session
    ///- Parameter userID: User ID
    ///- Parameter completion: User info response handler
    public func getUserInfo(_ userID: Int, completion: @escaping (_ result: Result<User, YMError>) -> Void)
    {
        getUserInfoByApi(userIdOrNickname: String(userID), completion: completion)
    }
    ///Get user info by defined nickname. Can be executed without active session
    ///- Parameter nickname: User nickname
    ///- Parameter completion: User info response handler
    public func getUserInfo(_ nickname: String, completion: @escaping (_ result: Result<User, YMError>) -> Void)
    {
        getUserInfoByApi(userIdOrNickname: nickname, completion: completion)
    }
    ///Get account settings
    ///- Parameter completion: Parsed account settings response handler
    public func getAccountSettings(completion: @escaping (_ result: Result<UserSettings, YMError>) -> Void)
    {
        getAccountSettingsByApi(token: accountSecret, completion: completion)
    }
    ///Update defined account settings
    ///- Parameter values: Updated settings values
    ///- Parameter completion: Parsed account settings response handler
    public func setAccountSettings(values: [UserSettings.EditCodingKeys: Any], completion: @escaping (_ result: Result<UserSettings, YMError>) -> Void) {
        var editValues: [String: Any] = [:]
        for item in values {
            editValues[item.key.rawValue] = item.value
        }
        setAccountSettingsByApi(token: accountSecret, editValues: editValues, completion: completion)
    }
    ///Get account info with radio-related fields
    ///- Parameter completion: Parsed account info including radio-related fields response handler
    public func getRotorAccountStatus(completion: @escaping (_ result: Result<Status, YMError>) -> Void)
    {
        getRotorAccountStatusByApi(token: accountSecret, completion: completion)
    }
    ///Get account purchase suggestions (subscriptions and others)
    ///- Parameter completion: Account purchase suggestions response handler
    public func getAccountPurchaseSuggestions(completion: @escaping (_ result: Result<PurchaseSuggestions, YMError>) -> Void)
    {
        getPurchaseSuggestionsByApi(token: accountSecret, completion: completion)
    }
    ///Get account alerts' permissions
    ///- Parameter completion: Account alerts' permissions response handler
    public func getAccountPermissionAlerts(completion: @escaping (_ result: Result<PermissionAlert, YMError>) -> Void)
    {
        getAccountPermissionAlertsByApi(token: accountSecret, completion: completion)
    }
    ///Send promo code for activation. For brute force you have only 10 attempts
    ///- Parameter code: Promo code string
    ///- Parameter completion: Promo code accept status response handler
    public func consumePromoCode(_ code: String, completion: @escaping (_ result: Result<PromoCodeStatus, YMError>) -> Void) {
        sendPromoCodeByApi(token: accountSecret, code: code, lang: apiLang, completion: completion)
    }
    ///Get account experimental settings values
    ///- Parameter completion: Experimental settings dictionary response handler
    public func getAccountExperiments(completion: @escaping (_ result: Result<[String: Any], YMError>) -> Void) {
        getAccountExperimentsByApi(token: accountSecret, completion: completion)
    }
    
    ///Get account feed. It includes daily playlists, charts and others blocks
    ///- Parameter completion: Account parsed feed object response handler
    public func getFeed(completion: @escaping (_ result: Result<Feed, YMError>) -> Void)
    {
        getFeedByApi(token: accountSecret, completion: completion)
    }
    
    ///Get landing blocks
    ///- Parameter blocks: Set of blocks for retrieving
    ///- Parameter completion: Retrieved landing blocks response handler
    public func getLanding(blocks: [LandingBlock], completion: @escaping (_ result: Result<Landing, YMError>) -> Void) {
        getLandingByApi(token: accountSecret, blocks: blocks.map({ block in
            return block.rawValue
        }), completion: completion)
    }
    ///Get landing promotions
    ///- Parameter feedPromotionId: Promotion ID in feed API response (Promotion block -> Block entity -> Promotion instance ID)
    ///- Parameter completion: Retrieved landing blocks response handler
    public func getPromotions(feedPromotionId: String, completion: @escaping (_ result: Result<Promotion, YMError>) -> Void) {
        getPromotionsByApi(token: accountSecret, feedBlockID: feedPromotionId, completion: completion)
    }
    ///Get music chart
    ///Note: chart_option - это постфикс к запросу из поля `menu` чарта. Например, на сайте можно выбрать глобальный (world) чарт или российский (russia).
    ///- Parameter option: Chart retrieve option keyword. Available options: 'world', 'russia'
    ///- Parameter completion: Retrieved chart data response handler
    public func getChart(option: String = "world", completion: @escaping (_ result: Result<ChartList, YMError>) -> Void) {
        getChartByApi(token: accountSecret, option: option, completion: completion)
    }
    ///Get podcasts feed
    ///- Parameter completion: Parsed podcasts response handler
    public func getPodcasts(completion: @escaping (_ result: Result<LandingList, YMError>) -> Void) {
        getPodcastsByApi(token: accountSecret, completion: completion)
    }
    ///Get available music genres keyes
    ///- Parameter completion: Music genres array response handler
    public func getGenres(completion: @escaping (_ result: Result<[Genre], YMError>) -> Void) {
        getGenresByApi(token: accountSecret, completion: completion)
    }
    
    
    ///Get info about defined queue
    ///- Parameter queueId: Queue ID
    ///- Parameter completion: Queue retrieved info response handler
    public func getQueueData(queueId: String, completion: @escaping (_ result: Result<Queue, YMError>) -> Void) {
        getQueueDataByApi(token: accountSecret, queueId: queueId, completion: completion)
    }
    ///Get all queues for current device
    ///- Parameter completion: Device queues info response handler
    public func getCurrentDeviceQueuesList(completion: @escaping (_ result: Result<QueueList, YMError>) -> Void) {
        getQueuesList(device: device, completion: completion)
    }
    ///Get all queues fro defined device
    ///- Parameter device: Device info
    ///- Parameter completion: Music genres array response handler
    public func getQueuesList(device: YMDevice, completion: @escaping (_ result: Result<QueueList, YMError>) -> Void) {
        getQueuesListByApi(token: accountSecret, device: device.deviceHeader, completion: completion)
    }
    ///Create new queue for defined device
    ///- Parameter queue: Queue instance without 'ID' and 'modified' info
    ///- Parameter device: Device info
    ///- Parameter completion: Accepted play queue (with 'ID' and 'modified') response handler
    public func createQueue(queue: Queue, device: YMDevice, completion: @escaping (_ result: Result<Queue, YMError>) -> Void) {
        createQueueByApi(token: accountSecret, queue: queue, device: device.deviceHeader, completion: completion)
    }
    ///Create new queue for current device
    ///- Parameter queue: Queue instance without 'ID' and 'modified' info
    ///- Parameter completion: Accepted play queue (with 'ID' and 'modified') response handler
    public func createQueueForCurrentDevice(queue: Queue, completion: @escaping (_ result: Result<Queue, YMError>) -> Void) {
        createQueueByApi(token: accountSecret, queue: queue, device: device.deviceHeader, completion: completion)
    }
    ///Update queue play index from current device
    ///- Parameter queueId: Queue ID
    ///- Parameter newIndex: Queue new play index
    ///- Parameter completion: Queue play index update status response handler
    public func setQueueIndexForCurrDevice(queueId: String, newIndex: Int, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        setQueueIndex(queueId: queueId, newIndex: newIndex, device: device, completion: completion)
    }
    ///Update queue play index from defined device
    ///- Parameter queueId: Queue ID
    ///- Parameter device: Device info
    ///- Parameter newIndex: Queue new play index
    ///- Parameter completion: Queue play index update status response handler
    public func setQueueIndex(queueId: String, newIndex: Int, device: YMDevice, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        setQueueCurrentIndexByApi(token: accountSecret, queueId: queueId, newIndex: newIndex, device: device.deviceHeader, completion: completion)
    }
    
    ///Get label related artists
    ///- Parameter labelId: Label ID
    ///- Parameter page: Page index
    ///- Parameter completion: Label related artists response handler
    public func getLabelArtists(labelId: String, page: Int, completion: @escaping (_ result: Result<MusicLabel, YMError>) -> Void) {
        getLabelArtistsByApi(token: accountSecret, labelID: labelId, page: page, completion: completion)
    }
    ///Get label related albums
    ///- Parameter labelId: Label ID
    ///- Parameter page: Page index
    ///- Parameter completion: Label related albums response handler
    public func getLabelAlbums(labelId: String, page: Int, completion: @escaping (_ result: Result<MusicLabel, YMError>) -> Void) {
        getLabelAlbumsByApi(token: accountSecret, labelID: labelId, page: page, completion: completion)
    }
    
    
    ///Search tracks, albums, artists by text phrase
    ///- Parameter text: Search phrase
    ///- Parameter noCorrect: True - for search phrase at back-end without correction, false - correct search phrase
    ///- Parameter type: Accepted types of search objects (tracks, albums, artists, playlists, podcasts, users, all)
    ///- Parameter page: Search page index
    ///- Parameter includeBestPlaylists: Include best playlists marker
    ///- Parameter completion: Search data response handler
    public func search(text: String, noCorrect: Bool, type: SearchType = .all, page: Int, includeBestPlaylists: Bool, completion: @escaping (_ result: Result<Search, YMError>) -> Void) {
        searchByApi(token: accountSecret, text: text, noCorrect: noCorrect, type: type.stringType, page: page, includeBestPlaylists: includeBestPlaylists, completion: completion)
    }
    ///Get text suggestions for further search by search phrase
    ///- Parameter text: Search phrase
    ///- Parameter completion: Search suggestions array response handler
    public func getSearchSugggestion(text: String, completion: @escaping (_ result: Result<Suggestion, YMError>) -> Void) {
        getSearchSuggestionsByApi(token: accountSecret, part: text, completion: completion)
    }
    ///Get search history items
    ///- Parameter completion: Search history items array response handler
    public func getSearchHistory(completion: @escaping (_ result: Result<[SearchHistoryItem], YMError>) -> Void) {
        getSearchHistoryByApi(token: accountSecret, userId: String(accountUid), completion: completion)
    }
    ///Feedback search history item (NOT TESTED PROPERLY!!!)
    ///- Parameter feedback: Search history object info
    ///- Parameter completion: Feedback search history status response handler
    public func feedbackSearchHistory(_ feedback: SearchFeedback, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        feedbackSearchHistoryByApi(token: accountSecret, absBlockPosition: feedback.absoluteBlockPosition, absPosition: feedback.absolutePosition, blockPosition: feedback.blockPosition, blockType: feedback.blockType, clickType: feedback.clickType, clientNow: feedback.clientNow, entityId: feedback.entityId, page: feedback.page, position: feedback.position, query: feedback.query, searchRequestId: feedback.searchRequestId, timestamp: feedback.timestamp, completion: completion)
    }
    ///Clear search history for account
    ///- Parameter completion: Clear search history status response handler
    public func clearSearchHistory(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        clearSearchHistoryByApi(token: accountSecret, userId: String(accountUid), completion: completion)
    }
    
    
    ///Get account recent lsiten history
    ///- Parameter tracksCount: Count of tracks data for each context object
    ///- Parameter contextTypes: Acceptable context types for get (artists, albums, playlists etc)
    ///- Parameter contextCount: Maximum count of context object in response
    ///- Parameter completion: Recent listen history object response handler
    public func getRecentListenHistory(tracksCount: Int, contextTypes: [ListenHistoryContextType], contextCount: Int = 30, completion: @escaping (_ result: Result<ListenHistory, YMError>) -> Void) {
        getRecentListenListByApi(token: accountSecret, userId: String(accountUid), tracksCount: tracksCount, contextTypes: contextTypes.map({ type in return type.rawValue}), contextCount: contextCount, completion: completion)
    }
    
    
    ///Get playlists data by its IDs
    ///- Parameter userId: Playlist owner ID
    ///- Parameter playlistsId: Playlists IDs array
    ///- Parameter completion: Retrieved playlists response handler
    public func getPlaylists(userId: String, playlistsId: [String], completion: @escaping (_ result: Result<[Playlist], YMError>) -> Void) {
        getPlaylistsByApi(token: accountSecret, userId: userId, playlistIds: playlistsId, completion: completion)
    }
    ///Get user-owned playlists data
    ///- Parameter userId: Playlists owner ID
    ///- Parameter completion: Retrieved playlists response handler
    public func getUserPlaylists(userId: String, completion: @escaping (_ result: Result<[Playlist], YMError>) -> Void) {
        getUserPlaylistsByApi(token: accountSecret, userId: userId, completion: completion)
    }
    ///Get new playlists data
    ///- Parameter completion: Retrieved new playlists response handler
    public func getNewPlaylists(completion: @escaping (_ result: Result<LandingList, YMError>) -> Void) {
        getNewPlaylistsByApi(token: accountSecret, completion: completion)
    }
    ///Get playlists data by defined tag
    ///- Parameter tagId: Tag ID
    ///- Parameter completion: Retrieved tag playlists response handler
    public func getPlaylistsByTag(tagId: String, completion: @escaping (_ result: Result<TagResult, YMError>) -> Void) {
        getTagPlaylistsByApi(token: accountSecret, tagId: tagId, completion: completion)
    }
    ///Get recommended playlists for defined
    ///- Parameter userId: The defined playlist owner ID
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter completion: Retrieved recommended playlists response handler
    public func getPlaylistRecommendations(userId: String, playlistId: String, completion: @escaping (_ result: Result<PlaylistRecommendation, YMError>) -> Void) {
        getPlaylistRecommendationsByApi(token: accountSecret, userId: userId, playlistId: playlistId, completion: completion)
    }
    ///Create new empty playlist
    ///- Parameter title: Playlist title
    ///- Parameter visibility: Playlist visibility for other users
    ///- Parameter completion: Created playlist object data response handler
    public func createPlaylist(title: String, visibility: PlaylistVisibilityType = .public, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        createPlaylistByApi(token: accountSecret, ownerId: String(accountUid), title: title, visibilityType: visibility.rawValue, completion: completion)
    }
    ///Update playlist title
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter newTitle: New title for playlist
    ///- Parameter completion: Updated playlist object data response handler
    public func editPlaylistTitle(playlistId: String, newTitle: String, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        editPlaylistTitleByApi(token: accountSecret, ownerId: String(accountUid), playlistId: playlistId, newTitle: newTitle, completion: completion)
    }
    ///Update playlist visibility for other users
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter newVisibility: New visibility type for playlist
    ///- Parameter completion: Updated playlist object data response handler
    public func editPlaylistVisibility(playlistId: String, newVisibility: PlaylistVisibilityType, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        editPlaylistVisibilityByApi(token: accountSecret, ownerId: String(accountUid), playlistId: playlistId, newVisibility: newVisibility.rawValue, completion: completion)
    }
    ///Add single track to the playlist
    ///- Parameter ownerId: Playlist owner ID
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter trackId: Track ID
    ///- Parameter albumId: Track parent album ID
    ///- Parameter albumId: Track parent album ID
    ///- Parameter index: Track insert position
    ///- Parameter revision: Playlist stock revision
    ///- Parameter completion: Updated playlist object data response handler
    public func playlistInsertTrack(ownerId: String, playlistId: String, trackId: Int, albumId: Int, index: Int = 0, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        insertTrackToPlaylistByApi(token: accountSecret, ownerId: ownerId, playlistId: playlistId, trackId: trackId, albumId: albumId, index: index, revision: revision, completion: completion)
    }
    ///Add tracks to the playlist
    ///- Parameter ownerId: Playlist owner ID
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter tracksId: Tracks IDs
    ///- Parameter index: Track insert position
    ///- Parameter revision: Playlist stock revision
    ///- Parameter completion: Updated playlist object data response handler
    public func playlistInsertTracks(ownerId: String, playlistId: String, tracks: [TrackId], index: Int = 0, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        insertTracksToPlaylistByApi(token: accountSecret, ownerId: ownerId, playlistId: playlistId, tracksIds: tracks, index: index, revision: revision, completion: completion)
    }
    ///Remove tracks from the playlist
    ///- Parameter ownerId: Playlist owner ID
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter from: Remove start position
    ///- Parameter to: Remove end position
    ///- Parameter revision: Playlist stock revision
    ///- Parameter completion: Updated playlist object data response handler
    public func playlistDeleteTracks(ownerId: String, playlistId: String, from: Int, to: Int, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
        deleteTracksFromPlaylistByApi(token: accountSecret, ownerId: ownerId, playlistId: playlistId, from: from, to: to, revision: revision, completion: completion)
    }
    ///Create new playlist by importing tracks' names
    ///- Parameter title: Playlist title
    ///- Parameter tracks: Tracks' array. Each track node has format '{Authors} - {Track name}'
    ///- Parameter completion: Import playlist init status response handler
    public func importPlaylist(title: String, tracks: [String], completion: @escaping (_ result: Result<String, YMError>) -> Void)
    {
        importTracksIntoNewPlaylistByApi(token: accountSecret, title: title, tracksInfo: tracks, completion: completion)
    }
    ///Get playlist import status
    ///- Parameter importCode: Playlist import ID
    ///- Parameter completion: Import playlist check status response handler
    public func getPlaylistImportStatus(importCode: String, completion: @escaping (_ result: Result<PlaylistImportStatus, YMError>) -> Void)
    {
        getImportTracksStatusByApi(token: accountSecret, importCode: importCode, completion: completion)
    }
    ///Remove playlist
    ///- Parameter playlistId: Playlist ID ('kind')
    ///- Parameter completion: Remove playlist status response handler
    public func removeUserPlaylist(playlistId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        deletePlaylistByApi(token: accountSecret, ownerId: String(accountUid), playlistId: playlistId, completion: completion)
    }
    ///Get liked playlists
    ///- Parameter completion: Liked playlists array response handler
    public func getLikedPlaylists(completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void) {
        getLikedPlaylistsByApi(token: accountSecret, userId: String(accountUid), completion: completion)
    }
    ///Like the playlists
    ///- Parameter playlistsIds: Playlists IDs ('kind')
    ///- Parameter completion: Like playlists status response handler
    public func likePlaylists(playlistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        addLikesPlaylistByApi(token: accountSecret, userId: String(accountUid), playlistIds: playlistIds, completion: completion)
    }
    ///Remove likes for the playlists
    ///- Parameter playlistsIds: Playlists IDs ('kind')
    ///- Parameter completion: Like playlists status response handler
    public func removeLikePlaylists(playlistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        removeLikesPlaylistByApi(token: accountSecret, userId: String(accountUid), playlistIds: playlistIds, completion: completion)
    }
    
    
    ///Get tracks data
    ///- Parameter trackIds: Tracks IDs
    ///- Parameter positions: Include track positions info
    ///- Parameter completion: Retrieved tracks array data response handler
    public func getTracks(trackIds: [String], positions: Bool, completion: @escaping (_ result: Result<[Track], YMError>) -> Void) {
        getTracksByApi(token: accountSecret, trackIds: trackIds, positions: positions, completion: completion)
    }
    ///Get similar tracks for the defined one
    ///- Parameter trackId: Track ID
    ///- Parameter completion: Similar tracks object response handler
    public func getSimilarTracks(trackId: String, completion: @escaping (_ result: Result<TracksSimilar, YMError>) -> Void) {
        getSimilarTracksByApi(token: accountSecret, trackId: trackId, completion: completion)
    }
    ///Get track supplement
    ///- Parameter trackId: Track ID
    ///- Parameter completion: Supplement tracks object response handler
    public func getTrackSupplement(trackId: String, completion: @escaping (_ result: Result<Supplement, YMError>) -> Void)
    {
        getTrackSupplementByApi(token: accountSecret, trackId: trackId, completion: completion)
    }
    ///Get liked tracks
    ///- Parameter modifiedRevision: Like library revision. If nil, returns actual revision
    ///- Parameter completion: Liked tracks library object response handler
    public func getLikedTracks(modifiedRevision: Int?, completion: @escaping (_ result: Result<LikeLibrary, YMError>) -> Void) {
        getLikedTracksByApi(token: accountSecret, userId: String(accountUid), modifiedRevision: modifiedRevision, completion: completion)
    }
    ///Get disliked tracks
    ///- Parameter modifiedRevision: Dislike library revision. If nil, returns actual revision
    ///- Parameter completion: Disliked tracks library object response handler
    public func getDislikedTracks(modifiedRevision: Int?, completion: @escaping (_ result: Result<LikeLibrary, YMError>) -> Void) {
        getDislikedTracksByApi(token: accountSecret, userId: String(accountUid), modifiedRevision: modifiedRevision, completion: completion)
    }
    ///Like the tracks
    ///- Parameter trackIds: Tracks IDs
    ///- Parameter completion: Modified like library revision number response handler
    public func likeTracks(trackIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        addLikesTrackByApi(token: accountSecret, userId: String(accountUid), tracksIds: trackIds, completion: completion)
    }
    ///Remove likes for the defined tracks
    ///- Parameter trackIds: Tracks IDs
    ///- Parameter completion: Modified like library revision number response handler
    public func removeLikeTracks(trackIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        removeLikesTrackByApi(token: accountSecret, userId: String(accountUid), tracksIds: trackIds, completion: completion)
    }
    ///Add the defined tracks for disliked library
    ///- Parameter trackIds: Tracks IDs
    ///- Parameter completion: Modified dislike library revision number response handler
    public func dislikeTracks(trackIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        addDislikesTrackByApi(token: accountSecret, userId: String(accountUid), tracksIds: trackIds, completion: completion)
    }
    ///Remove dislikes for the defined tracks
    ///- Parameter trackIds: Tracks IDs
    ///- Parameter completion: Modified dislike library revision number response handler
    public func removeDislikeTracks(trackIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
        removeDislikesTrackByApi(token: accountSecret, userId: String(accountUid), tracksIds: trackIds, completion: completion)
    }
    
    
    ///Get info about the defined albums
    ///- Parameter albumIds: Albums IDs
    ///- Parameter completion: Retrieved albums array data response handler
    public func getAlbums(albumIds: [String], completion: @escaping (_ result: Result<[Album], YMError>) -> Void) {
        getAlbumsByApi(token: accountSecret, albumIds: albumIds, completion: completion)
    }
    ///Get new albums
    ///- Parameter completion: Retrieved new albums object response handler
    public func getNewAlbums(completion: @escaping (_ result: Result<LandingList, YMError>) -> Void) {
        getNewAlbumsByApi(token: accountSecret, completion: completion)
    }
    ///Get albums with included tracks' data
    ///- Parameter albumId: Albums ID
    ///- Parameter completion: Retrieved album data response handler
    public func getAlbumWithTracksData(albumId: String, completion: @escaping (_ result: Result<Album, YMError>) -> Void) {
        getAlbumWithTracksByApi(token: accountSecret, albumId: albumId, completion: completion)
    }
    ///Get user liked albums
    ///- Parameter rich: Inlcuding rich albums
    ///- Parameter completion: Retrieved liked albums array response handler
    public func getLikedAlbums(rich: Bool, completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void) {
        getLikedAlbumsByApi(token: accountSecret, userId: String(accountUid), rich: rich, completion: completion)
    }
    ///Like the defined albums
    ///- Parameter albumIds: Albums IDs
    ///- Parameter completion: Like albums status response handler
    public func likeAlbums(albumIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        addLikesAlbumByApi(token: accountSecret, userId: String(accountUid), albumIds: albumIds, completion: completion)
    }
    ///Remove likes for the defined albums
    ///- Parameter albumIds: Albums IDs
    ///- Parameter completion: Remove likes' albums status response handler
    public func removeLikeAlbums(albumIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        removeLikesAlbumByApi(token: accountSecret, userId: String(accountUid), albumIds: albumIds, completion: completion)
    }
    
    
    ///Get info about the defined artists
    ///- Parameter artistIds: Artists IDs
    ///- Parameter completion: Retrieved artists array data response handler
    public func getArtists(artistIds: [String], completion: @escaping (_ result: Result<[Artist], YMError>) -> Void) {
        getArtistsByApi(token: accountSecret, artistIds: artistIds, completion: completion)
    }
    ///Get brief info about the artist
    ///- Parameter artistId: Artist ID
    ///- Parameter completion: Retrieved artist brief data response handler
    public func getArtistShortInfo(artistId: String, completion: @escaping (_ result: Result<ArtistShortInfo, YMError>) -> Void) {
        getArtistShortInfoByApi(token: accountSecret, artistId: artistId, completion: completion)
    }
    ///Get artist tracks'
    ///- Parameter artistId: Artist ID
    ///- Parameter page: Artist tracks page index
    ///- Parameter pageSize: Count of tracks per page
    ///- Parameter completion: Retrieved artist tracks page response handler
    public func getArtistTracks(artistId: String, page: Int = 0, pageSize: Int = 20, completion: @escaping (_ result: Result<ArtistTracks, YMError>) -> Void) {
        getArtistTracksByApi(token: accountSecret, artistId: artistId, page: page, pageSize: pageSize, completion: completion)
    }
    ///Get artist direct albums
    ///- Parameter artistId: Artist ID
    ///- Parameter page: Artist albums page index
    ///- Parameter pageSize: Count of artist albums per page
    ///- Parameter sortBy: Albums sort type. Available values: rating, year
    ///- Parameter completion: Retrieved artist albums page response handler
    public func getArtistDirectAlbums(artistId: String, page: Int = 0, pageSize: Int = 20, sortBy: ArtistAlbumsSortBy, completion: @escaping (_ result: Result<ArtistAlbums, YMError>) -> Void) {
        getArtistDirectAlbumsByApi(token: accountSecret, artistId: artistId, page: page, pageSize: pageSize, sortBy: sortBy.rawValue, completion: completion)
    }
    ///Get user liked artists
    ///- Parameter likeTs: Inlcude like timestamp info
    ///- Parameter completion: Retrieved user liked artists array response handler
    public func getLikedArtists(likeTs: Bool, completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void) {
        getLikedArtistsByApi(token: accountSecret, userId: String(accountUid), likeTs: likeTs, completion: completion)
    }
    ///Like the defined artists
    ///- Parameter artistIds: Artists IDs
    ///- Parameter completion: Like artists status response handler
    public func likeArtists(artistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        addLikesArtistByApi(token: accountSecret, userId: String(accountUid), artistIds: artistIds, completion: completion)
    }
    ///Remove likes for the defined artists
    ///- Parameter artistIds: Artists IDs
    ///- Parameter completion: Remove likes' artists status response handler
    public func removeLikeArtists(artistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        removeLikesArtistByApi(token: accountSecret, userId: String(accountUid), artistIds: artistIds, completion: completion)
    }
    
    
    ///Get user radio stations dashboard
    ///- Parameter completion: Radio dashboard data response handler
    public func getRadioStationsDashboard(completion: @escaping (_ result: Result<RadioDashboard, YMError>) -> Void) {
        getStationsDashboardByApi(token: accountSecret, completion: completion)
    }
    ///Get all available radio stations
    ///- Parameter completion: Radio stations array response handler
    public func getRadioStationsList(completion: @escaping (_ result: Result<[StationResult], YMError>) -> Void) {
        getRadioStationsListByApi(token: accountSecret, language: apiLang, completion: completion)
    }
    ///Get info about the defined radio station
    ///- Parameter stationId: Radio station ID
    ///- Parameter completion: Info about radio station response handler
    public func getRadioStationInfo(stationId: String, completion: @escaping (_ result: Result<[StationResult], YMError>) -> Void) {
        getRadioStationInfoByApi(token: accountSecret, stationId: stationId, completion: completion)
    }
    ///Get radio station tracks batch. Usually returns 5 tracks
    ///- Parameter stationId: Radio station ID
    ///- Parameter settings2: Use new settings format. Default is true
    ///- Parameter lastTrackId: Last play track ID. For first batch retrieve must be nil
    ///- Parameter completion: Radio station tracks batch data response handler
    public func getRadioStationTracksBatch(stationId: String, settings2: Bool = true, lastTrackId: String?, completion: @escaping (_ result: Result<StationTracksResult, YMError>) -> Void) {
        getRadioStationTracksBatchByApi(token: accountSecret, stationId: stationId, settings2: settings2, lastTrackId: lastTrackId, completion: completion)
    }
    ///Send radio station start listening for the defined date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter timestamp8601: Listeting start timestamp (ISO 8601 format)
    ///- Parameter fromInfo: Info about user interface, where listening started
    ///- Parameter completion: Send event status response handler
    public func sendRadioStationStartListening(stationId: String, timestamp8601: String, fromInfo: String = "", completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationStartedByApi(token: accountSecret, stationId: stationId, timestamp8601: timestamp8601, fromInfo: fromInfo, completion: completion)
    }
    ///Send radio station start listening for current date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter fromInfo: Info about user interface, where listening started
    ///- Parameter completion: Send event status response handler
    public func sendRadioStationStartListening(stationId: String, fromInfo: String = "", completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationStartedByApi(token: accountSecret, stationId: stationId, timestamp8601: DateUtil.isoFormat(), fromInfo: fromInfo, completion: completion)
    }
    ///Send radio station track start playing for the defined date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter timestamp8601: Listeting start timestamp (ISO 8601 format)
    ///- Parameter tracksBatchId: Tracks batch ID
    ///- Parameter trackId: Start playing track ID
    ///- Parameter completion: Send event status response handler
    public func sendRadioTrackStartListening(stationId: String, timestamp8601: String, tracksBatchId: String, trackId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackStartedByApi(token: accountSecret, stationId: stationId, timestamp8601: timestamp8601, tracksBatchId: tracksBatchId, trackId: trackId, completion: completion)
    }
    ///Send radio track start playing for current date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter tracksBatchId: Tracks batch ID
    ///- Parameter trackId: Start playing track ID
    ///- Parameter completion: Send event status response handler
    public func sendRadioTrackStartListening(stationId: String, tracksBatchId: String, trackId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackStartedByApi(token: accountSecret, stationId: stationId, timestamp8601: DateUtil.isoFormat(), tracksBatchId: tracksBatchId, trackId: trackId, completion: completion)
    }
    ///Send radio track finished playing for the defined date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter timestamp8601: Play finish timestamp (ISO 8601 format)
    ///- Parameter tracksBatchId: Tracks batch ID
    ///- Parameter trackId: Finish playing track ID
    ///- Parameter playedDurationInS: Played track time in seconds
    ///- Parameter completion: Send event status response handler
    public func sendRadioTrackFinished(stationId: String, timestamp8601: String, tracksBatchId: String, trackId: String, playedDurationInS: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackFinishedByApi(token: accountSecret, stationId: stationId, timestamp8601: timestamp8601, tracksBatchId: tracksBatchId, trackId: trackId, playedSeconds: playedDurationInS, completion: completion)
    }
    ///Send radio track finished playing for current date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter tracksBatchId: Tracks batch ID
    ///- Parameter trackId: Finish playing track ID
    ///- Parameter playedDurationInS: Played track time in seconds
    public func sendRadioTrackFinished(stationId: String, tracksBatchId: String, trackId: String, playedDurationInS: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackFinishedByApi(token: accountSecret, stationId: stationId, timestamp8601: DateUtil.isoFormat(), tracksBatchId: tracksBatchId, trackId: trackId, playedSeconds: playedDurationInS, completion: completion)
    }
    ///Send radio track user skip event for current date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter trackId: Finish playing track ID
    ///- Parameter playedSeconds: Played track time in seconds
    ///- Parameter completion: Send event status response handler
    public func sendRadioTrackSkip(stationId: String, trackId: String, playedSeconds: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackSkippedByApi(token: accountSecret, stationId: stationId, timestamp8601: DateUtil.isoFormat(), trackId: trackId, playedSeconds: playedSeconds, completion: completion)
    }
    ///Send radio track user skip event for the defined date and time
    ///- Parameter stationId: Radio station ID
    ///- Parameter timestamp8601: Track skip timestamp (ISO 8601 format)
    ///- Parameter trackId: Finish playing track ID
    ///- Parameter playedSeconds: Played track time in seconds
    ///- Parameter completion: Send event status response handler
    public func sendRadioTrackSkip(stationId: String, timestamp8601: String, trackId: String, playedSeconds: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        radioStationTrackSkippedByApi(token: accountSecret, stationId: stationId, timestamp8601: timestamp8601, trackId: trackId, playedSeconds: playedSeconds, completion: completion)
    }
    public func setRadioStationSettings(stationId: String, language: StationPreferredLanguageType, moodEnergy: StationMoodType, diversity: StationDiversityType, type: StationType, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
        setRadioStationSettingsByApi(token: accountSecret, stationId: stationId, language: language, moodEnergy: moodEnergy, diversity: diversity, type: type, completion: completion)
    }
}
