//
//  ApiFuncParams.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
extension ApiFunction {
    
    var parameters: [String: Any] {
        switch self {

        case .download: return [:]

        case .auth_init(let login, let lang, _, _, _, _, _, _, _, _): return [
            "client_id": clientId, "client_secret": clientSecret, "display_language": lang.rawValue, "login": login,
            "payment_auth_retpath": "yandexmusic%3A%2F%2Fam%2Fpayment_auth", "x_token_client_id": xTokenClientId, "x_token_client_secret": xTokenClientSecret
        ]
        case .auth_pass(let trackId, let pass, let captchaAnswer, let captchaKey):
            var dict: [String: Any] = ["password": pass, "track_id": trackId]
            if let g_answer = captchaAnswer, let g_key = captchaKey {
                dict["x_captcha_answer"] = g_answer
                dict["x_captcha_key"] = g_key
            }
            return dict
        case .auth_generate_token(let xToken, _, _, _, _, _, _, _): return ["access_token": xToken, "client_id": clientId, "client_secret": clientSecret, "grant_type": "x-token", "payment_auth_retpath": "yandexmusic%3A%2F%2Fam%2Fpayment_auth"]
        case .auth_legacy(let login, let pass, _, let captchaAnswer, let captchaKey):
            var dict: [String: Any] = ["grant_type": "password", "client_id": clientId, "client_secret": clientSecret, "username": login, "password": pass]
            if let g_answer = captchaAnswer, let g_key = captchaKey {
                dict["x_captcha_answer"] = g_answer
                dict["x_captcha_key"] = g_key
            }
            return dict

        case .account_status: return [:]
        case .account_avatar: return [:]
        case .rotor_account_status: return [:]
        case .account_experiments: return [:]
        case .account_settings: return [:]
        case .account_settings_edit(_, let values): return values
        case .purchase_suggestions: return [:]
        case .permission_alerts: return [:]
        case .consume_promo_code(let lang, _, let code): return ["code": code, "language": lang.rawValue]

        case .feed: return [:]
        case .play(let trackId, let albumId, let playlistId, let from, let fromCache, let playId, let userId, let trackLength, let totalPlayed, let endPositionPoints, _): return ["track-id": trackId, "from-cache": fromCache, "from": from, "play-id": playId, "uid": userId, "timestamp": DateUtil.isoFormat(), "track-length-seconds": trackLength, "total-played-seconds": totalPlayed, "end-position-seconds": endPositionPoints, "album-id":albumId, "playlistId": playlistId, "client-now": DateUtil.isoFormat()]
        case .after_track(let nextTrackId, let contextItem, let prevTrackId, let context, let type, let from, _): return ["from": from, "prevTrackId": prevTrackId, "nextTrackId": nextTrackId, "context": context, "contextItem": contextItem, "types": type]
        case .queue: return [:]
        case .queue_create(let queueJson, _, _): return queueJson
        case .queue_update_position(_, let currIndex, _, _): return ["currentIndex": currIndex, "isInteractive": false]
        case .queues_list: return [:]
            
        case .tracks(let ids, _, _):
            var paramString = ""
            for id in ids
            {
                paramString += id + ","
            }
            paramString = String(paramString[paramString.startIndex..<paramString.endIndex])
            return ["trackIds": paramString]
        case .tracks_similar: return [:]
        case .track_download_info: return [:]
        case .track_supplement: return [:]
            
        case .artists(let ids, _):
            var paramString = ""
            for id in ids
            {
                paramString += id + ","
            }
            paramString = String(paramString[paramString.startIndex..<paramString.endIndex])
            return ["artistIds": paramString]
        case .artist_short_info: return [:]
        case .artists_tracks: return [:]
        case .artists_direct_albums: return [:]
            
        case .albums(let ids, _):
            var paramString = ""
            for id in ids
            {
                paramString += id + ","
            }
            paramString = String(paramString[paramString.startIndex..<paramString.endIndex])
            return ["albumIds": paramString]
        case .new_albums: return [:]
        case .album_with_tracks: return [:]
            
        case .playlists(_, let ids, _):
            if (ids.count > 1)
            {
                return ["kinds": ids]
            }
            return [:]
        case .user_playlists: return [:]
        case .playlist_recommendations: return [:]
        case .new_playlists: return [:]
        case .tag_playlists: return [:]
        case .playlist_create(_, let title, let visibilityType, _): return ["title": title, "visibility": visibilityType]
        case .playlist_content_change(_, let playlistId, let revision, let changeOps, _): return ["kind": playlistId, "revision": revision, "diff": changeOps]
        case .playlist_delete: return [:]
        case .playlist_edit_title(_, _, let newTitle, _): return ["value": newTitle]
        case .playlist_edit_visibility(_, _, let newVisibility, _): return ["value": newVisibility]
            
        case .label_data: return [:]
            
        case .search: return [:]
        case .search_suggest: return [:]
        case .search_history: return [:]
        case .search_history_feedback(let absBlockPosition, let absPosition, let blockPosition, let blockType, let clickType, let clientNow, let entityId, let page, let position, let query, let searchRequestId, let timestamp, _): return ["absoluteBlockPosition": absBlockPosition, "absolutePosition": absPosition, "blockPosition": blockPosition, "blockType": blockType, "clickType": clickType, "clientNow": clientNow, "entityId": entityId, "page": page, "position": position, "query": query, "searchRequestId": searchRequestId, "timestamp": timestamp]
        case .search_history_clear: return [:]
            
        case .recent_listen: return [:]
            
        case .landing: return [:]
        case .promotions: return [:]
        case .chart: return [:]
        case .podcasts: return [:]
        case .genres: return [:]
            
        case .like_action(_, let objectsId, let objType, _, _):
            var paramString = ""
            for id in objectsId
            {
                paramString += id + ","
            }
            paramString = String(paramString[paramString.startIndex..<paramString.endIndex])
            return [objType + "-ids": paramString]
        case .dislike_action(_, let objectsId, let objType, _, _):
            var paramString = ""
            for id in objectsId
            {
                paramString += id + ","
            }
            paramString = String(paramString[paramString.startIndex..<paramString.endIndex])
            return [objType + "-ids": paramString]
        case .liked_artists: return [:]
        case .liked_albums: return [:]
        case .liked_tracks: return [:]
        case .disliked_tracks: return [:]
        case .liked_playlists: return [:]

        case .stations_dashboard: return [:]  
        case .stations_list: return [:]
        case .station_info: return [:]
        case .station_tracks: return [:]
        case .station_feedback_action(_, let actionType, let timestamp8601, let fromInfo, _, let playedSeconds, let trackId, _):
            var params: [String: Any] = ["type" : actionType, "timestamp": timestamp8601]
            if !trackId.isEmpty {
                params["trackId"] = trackId
            }
            if !fromInfo.isEmpty {
                params["from"] = fromInfo
            }
            if playedSeconds >= 0 {
                params["totalPlayedSeconds"] = playedSeconds
            }
            return params
        case .station_settings(_, let language, let moodEnergy, let diversity, let type, _): return ["language": language, "moodEnergy": moodEnergy, "diversity": diversity, "type": type]
        }
    }
}
