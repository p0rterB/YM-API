//
//  ApiFuncHeaders.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
extension ApiFunction {
    
    var headers: [String: String] {
        switch self {
        case .auth_init(_, let lang, _, _, _, _, _, _, _, _): return ["Accept-Language": lang.rawValue]
        case .auth_pass: return [:]
        case .auth_generate_token: return [:]
        case .auth_legacy(_, _, let lang, _, _): return ["Accept-Language": lang.rawValue]
        case .rotor_account_status(let secret): return ["Authorization": "OAuth " + secret]
        case .account_status(let secret): return ["Authorization": "OAuth " + secret]
        case .account_avatar(_, let secret): return ["Ya-Consumer-Authorization": "OAuth " + secret]
        case .user_info: return [:]
        case .account_experiments(let secret): return ["Authorization": "OAuth " + secret]
        case .account_settings(let secret): return ["Authorization": "OAuth " + secret]
        case .account_settings_edit(let secret, _): return ["Authorization": "OAuth " + secret]
        case .purchase_suggestions(let secret): return ["Authorization": "OAuth " + secret]
        case .permission_alerts(let secret): return ["Authorization": "OAuth " + secret]
        case .consume_promo_code(_, let secret, _): return ["Authorization": "OAuth " + secret]
            
        case .feed(let secret): return ["Authorization": "OAuth " + secret]
        case .play(_, _, _, _, _, _, _, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .after_track(_, _, _, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .queue(_, let secret): return ["Authorization": "OAuth " + secret]
        case .queue_create(_, let device, let secret): return [
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "OAuth " + secret,
            "X-Yandex-Music-Device": device]
        case .queue_update_position(_, _, let device, let secret): return ["Authorization": "OAuth " + secret, "X-Yandex-Music-Device": device]
        case .queues_list(let device, let secret): return ["Authorization": "OAuth " + secret, "X-Yandex-Music-Device": device]
            
        case .tracks(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .tracks_similar(_, let secret): return ["Authorization": "OAuth " + secret]
        case .track_download_info(_, let secret): return ["Authorization": "OAuth " + secret]
        case .track_supplement(_, let secret): return ["Authorization": "OAuth " + secret]
            
        case .artists(_, let secret): return ["Authorization": "OAuth " + secret]
        case .artist_short_info(_, let secret): return ["Authorization": "OAuth " + secret]
        case .artists_tracks(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .artists_direct_albums(_, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
            
        case .albums(_, let secret): return ["Authorization": "OAuth " + secret]
        case .new_albums(let secret): return ["Authorization": "OAuth " + secret]
        case .album_with_tracks(_, let secret): return ["Authorization": "OAuth " + secret]
            
        case .playlists(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .user_playlists(_, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_recommendations(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .new_playlists(let secret): return ["Authorization": "OAuth " + secret]
        case .tag_playlists(_, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_create(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_content_change(_, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_import(_, _, let secret): return [
            "Content-Type": "charset=UTF-8",
            "Authorization": "OAuth " + secret
        ]
        case .playlist_import_status(_, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_delete(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_edit_title(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .playlist_edit_visibility(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
            
        case .label_data(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
            
        case .search(_, _, _, _, _, let  secret): return ["Authorization": "OAuth " + secret]
        case .search_suggest(_, let secret): return ["Authorization": "OAuth " + secret]
        case .search_history(_, let secret): return ["Authorization": "OAuth " + secret]
        case .search_history_feedback(_, _, _, _, _, _, _, _, _, _, _, _, let secret): return
            [
                "Content-Type": "application/json; charset=UTF-8",
                "Authorization": "OAuth " + secret
            ]
        case .search_history_clear(_, let secret): return ["Authorization": "OAuth " + secret]
            
        case .recent_listen(_, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
            
        case .landing(_, let secret): return ["Authorization": "OAuth " + secret]
        case .promotions(_, let secret): return ["Authorization": "OAuth " + secret]
        case .chart(_, let secret): return ["Authorization": "OAuth " + secret]
        case .podcasts(let secret): return ["Authorization": "OAuth " + secret]
        case .genres(let secret): return ["Authorization": "OAuth " + secret]
            
        case .like_action(_, _, _, _, let  secret): return ["Authorization": "OAuth " + secret]
        case .dislike_action(_, _, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .liked_artists(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .liked_albums(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .liked_tracks(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .disliked_tracks(_, _, let secret): return ["Authorization": "OAuth " + secret]
        case .liked_playlists(_, let secret): return ["Authorization": "OAuth " + secret]
                
        case .stations_dashboard(let secret): return ["Authorization": "OAuth " + secret]
        case .stations_list(_, let secret): return ["Authorization": "OAuth " + secret]
        case .station_info(_, let secret): return ["Authorization": "OAuth " + secret]
        case .station_tracks(_, _, _, let secret): return ["Authorization": "OAuth " + secret]
        case .station_feedback_action(_, _, _, _, _, _, _, let secret): return [
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "OAuth " + secret
        ]
        case .station_settings(_, _, _, _, _, let secret): return [
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization": "OAuth " + secret
        ]
        default: return [:]
        }
    }
}
