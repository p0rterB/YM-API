//
//  ApiHttpMethod.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
extension ApiFunction {
    
    var method: String {
        switch self {
        case .download: return "GET"
        case .account_status: return "GET"
        case .rotor_account_status: return "GET"
        case .account_experiments: return "GET"
        case .account_settings: return "GET"
        case .purchase_suggestions: return "GET"
        case .permission_alerts: return "GET"
        case .feed: return "GET"
        case .after_track: return "GET"
        case .queue: return "GET"
        case .queues_list: return "GET"
        case .tracks_similar: return "GET"
        case .track_download_info: return "GET"
        case .track_supplement: return "GET"
        case .artists_tracks: return "GET"
        case .artists_direct_albums: return "GET"
        case .artist_short_info: return "GET"
        case .new_albums: return "GET"
        case .album_with_tracks: return "GET"
        case .playlists: return "GET"
        case .user_playlists: return "GET"
        case .playlist_recommendations: return "GET"
        case .new_playlists: return "GET"
        case .tag_playlists: return "GET"
        case .search: return "GET"
        case .search_suggest: return "GET"
        case .landing: return "GET"
        case .chart: return "GET"
        case .podcasts: return "GET"
        case .genres: return "GET"
        case .liked_artists: return "GET"
        case .liked_albums: return "GET"
        case .liked_tracks: return "GET"
        case .disliked_tracks: return "GET"
        case .liked_playlists: return "GET"
        case .stations_dashboard: return "GET"
        case .stations_list: return "GET"
        case .station_info: return "GET"
        case .station_tracks: return "GET"
        default: return "POST"
        }
    }
}
