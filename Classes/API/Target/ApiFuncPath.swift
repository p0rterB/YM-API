//
//  ApiFuncPath.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
extension ApiFunction {
    
    var path: String {
        switch self {
        //General
        case .download: return ""
        //Auth
        case .auth_init(_, _, let appId, let uuid, let appVersionName, let manufacturer, let deviceId, let deviceName, let platform, let model): return "2/bundle/mobile/start/?app_id=" + appId + "&uuid=" + uuid + "&app_version_name=" + appVersionName + "&manufacturer=" + manufacturer + "&deviceid=" + deviceId + "&device_name" + deviceName + "&device_id=" + deviceId + "&app_platform=" + platform + "&model=" + model
        case .auth_pass: return "1/bundle/mobile/auth/password"
        case .auth_generate_token(_, let appId, let appVersionName, let deviceId, let manufacturer, let deviceName, let platform, let model): return "1/token?app_id=" + appId + "&app_version_name=" + appVersionName + "&manufacturer=" + manufacturer + "&deviceid=" + deviceId + "&device_name" + deviceName + "&device_id=" + deviceId + "&app_platform=" + platform + "&model=" + model
        case .auth_legacy: return "token"
        //Account
        case .account_status: return "account/status"
        case .account_avatar(let size, _): return "1/bundle/account/short_info?avatar_size=islands-" + String(size)
        case .user_info(let userIdOrNickname): return "users/" + userIdOrNickname
        case .rotor_account_status: return "rotor/account/status"
        case .account_experiments: return "account/experiments"
        case .account_settings, .account_settings_edit: return "account/settings"
        case .purchase_suggestions: return "settings"
        case .permission_alerts: return "permission-alerts"
        case .consume_promo_code: return "account/consume-promo-code"
        //Player
        case .feed: return "feed"
        case .play: return "play-audio"
        case .after_track: return "after-track"
        case .queue(let queueId, _): return "queues/" + queueId
        case .queue_create: return "queues"
        case .queue_update_position(let queueId, _, _, _): return "queues/" + queueId + "/update-position"
        case .queues_list: return "queues"
            
        case .tracks(_, let positions, _): return "tracks?with-positions=" + String(positions)
        case .tracks_similar(let trackId, _): return "tracks/" + trackId + "/similar"
        case .track_download_info(let trackId, _): return "tracks/" + trackId + "/download-info"
        case .track_supplement(let trackId, _): return "tracks/" + trackId + "/supplement"
            
        case .artists: return "artists"
        case .artist_short_info(let artistId, _): return "artists/" + artistId + "/brief-info"
        case .artists_tracks(let artistId, let page, let pageSize, _): return "artists/" + artistId + "/tracks?page=" + String(page) + "&page-size=" + String(pageSize)
        case .artists_direct_albums(let artistId, let page, let pageSize, let sortBy, _): return "artists/" + artistId + "/direct-albums?page=" + String(page) + "&page-size=" + String(pageSize) + "&sort-by=" + sortBy
            
        case .albums: return "albums"
        case .new_albums: return "landing3/new-releases"
        case .album_with_tracks(let albumId, _): return "albums/" + albumId + "/with-tracks"
            
        case .playlists(let userID, let ids, _):
            var path = "users/" + userID + "/playlists"
            if (ids.count == 1)
            {
                path += "/" + ids[0]
            } else {
                path += "/list"
            }
            return path
        case .user_playlists(let userId, _): return "users/" + userId + "/playlists/list"
        case .playlist_recommendations(let userId, let playlistId, _): return "users/" + userId + "/playlists/" + playlistId + "/recommendations"
        case .new_playlists: return "landing3/new-playlists"
        case .tag_playlists(let tagId, _): return "tags/" + tagId + "/playlist-ids"
        case .playlist_create(let ownerId, _, _, _): return "users/" + ownerId + "/playlists/create"
        case .playlist_content_change(let ownerId, let playlistId, _, _, _): return "users/" + ownerId + "/playlists/" + playlistId + "/change"
        case .playlist_import(let title, _, _): return "import/playlist?title=" + title
        case .playlist_import_status(let importCode, _): return "import/" + importCode + "/playlists"
        case .playlist_delete(let ownerId, let playlistId, _): return "users/" + ownerId + "/playlists/" + playlistId + "/delete"
        case .playlist_edit_title(let ownerId, let playlistId, _, _): return "users/" + ownerId + "/playlists/" + playlistId + "/name"
        case .playlist_edit_visibility(let ownerId, let playlistId, _, _): return "users/" + ownerId + "/playlists/" + playlistId + "/visibility"
            
        case .label_data(let labelID, let dataType, let page, _): return "/labels/" + labelID + "/" + dataType + "?page=" + String(page)
            
        case .search(let text, let noCorrect, let type, let page, let includeBestPlaylists, _):
            let queryParams = "text=" + text + "&nocorrect=" + String(noCorrect) + "&type=" + type + "&page=" + String(page) + "&playlist-in-best=" + String(includeBestPlaylists)
            return "search?" + queryParams
        case .search_suggest(let part, _): return "search/suggest?part=" + part
        case .search_history(let userID, _): return "users/" + userID + "/search-history"
        case .search_history_feedback: return "search/feedback"
        case .search_history_clear(let userID, _): return "users/" + userID + "/search-history/clear"
            
        case .recent_listen(let userID, let tracksCount, let contextTypes, let contextCount, _):
            let contexts: String = contextTypes.joined(separator: ",")
            return "users/" + userID + "/contexts?trackCount=" + String(tracksCount) + "&types=" + contexts + "&contextCount=" + String(contextCount)
            
        case .landing(let blocks, _):
            var blocksStr: String = ""
            for block in blocks {
                blocksStr += block + ","
            }
            blocksStr = String(blocksStr[blocksStr.startIndex..<blocksStr.endIndex])
            return "landing3?blocks=" + blocksStr + "&eitherUserId=10254713668400548221"
        case .promotions(let feedBlockID, _): return "/feed/promotions/" + feedBlockID
        case .chart(let option, _):
            var path = "landing3/chart"
            if (option.compare("") != .orderedSame)
            {
                path += "/" + option
            }
            return path
        case .podcasts: return "landing3/podcasts"
        case .genres: return "genres"
            
        case .like_action(let userID, _, let objType, let remove, _):
            let action = remove ? "remove" : "add-multiple"
            return "users/" + userID + "/likes/" + objType + "s/" + action
        case .dislike_action(let userID, _, let objType, let remove, _):
            let action = remove ? "remove" : "add-multiple"
            return "users/" + userID + "/dislikes/" + objType + "s/" + action
        case .liked_artists(let userId, let likeTs, _):
            var path = "users/" + userId + "/likes/artists"
            if (likeTs) {
                path += "?with-timestamps=" + String(likeTs)
            }
            return path
        case .liked_albums(let userId, let rich, _):
            var path = "users/" + userId + "/likes/albums"
            if (rich) {
                path += "?rich=" + String(rich)
            }
            return path
        case .liked_tracks(let userId, let modifiedRevision, _):
            var path = "users/" + userId + "/likes/tracks"
            if let g_revision = modifiedRevision {
                path += "?if-modified-since-revision=" + String(g_revision)
            }
            return path
        case .disliked_tracks(let userId, let modifiedRevision, _): var path = "users/" + userId + "/dislikes/tracks"
            if let g_revision = modifiedRevision {
                path += "?if-modified-since-revision=" + String(g_revision)
            }
            return path
        case .liked_playlists(let userId, _): return "users/" + userId + "/likes/playlists"

        case .stations_dashboard: return "rotor/stations/dashboard"
        case .stations_list(let language, _): return "rotor/stations/list?language=" + language
        case .station_info(let stationId, _): return "rotor/station/" + stationId + "/info"
        case .station_tracks(let stationId, let settings2, let lastTrackId, _):
            var path = "rotor/station/" + stationId + "/tracks?settings2=" + String(settings2)
            if !lastTrackId.isEmpty {
                path += "&queue=" + lastTrackId
            }
            return path
        case .station_feedback_action(let stationId, _, _, _, let tracksBatchId, _, _, _):
            var path = "rotor/station/" + stationId + "/feedback"
            if (!tracksBatchId.isEmpty) {
                path += "?batch-id=" + tracksBatchId
            }
            return path
        case .station_settings(let stationId, _, _, _, _, _): return "rotor/station/" + stationId + "/settings3"
        }
    }
}
