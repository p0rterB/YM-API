//
//  LandingBlock.swift
//  YM-API
//
//  Created by Developer on 01.09.2021.
//

///Represents landing blocks available types
public enum LandingBlock: String, CaseIterable {
    case personal_playlists = "personal-playlists"
    case promotions
    case new_releases = "new-releases"
    case new_playlists = "new-playlists"
    case mixes
    case chart
    case artists
    case albums
    case playlists
    case  play_contexts
}
