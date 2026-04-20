//
//  SearchType.swift
//  YM-API
//
//  Created by Developer on 25.08.2021.
//

import Foundation

public enum SearchType: UInt8 {
    case all
    case artist
    case user
    case playlist
    case track
    case podcast
    case podcast_episode
}

extension SearchType {
    public var stringType: String {
        switch self {
        case .all: return "all"
        case .artist: return "artist"
        case .user: return "user"
        case .playlist: return "playlist"
        case .track: return "track"
        case .podcast: return "podcast"
        case .podcast_episode: return "podcast_episode"
        }
    }
}
