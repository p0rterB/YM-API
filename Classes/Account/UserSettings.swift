//
//  UserSettings.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Account user settings
public class UserSettings: Decodable {
    
    //Note: Доступные значения для поля `theme`: `white`, `black`. Доступные значения для полей `user_music_visibility` и `user_social_visibility`: `private`, `public`.

    //Notes: `promos_disabled`, `ads_disabled`, `rbt_disabled` устарели и не работают. `last_fm_scrobbling_enabled`, `facebook_scrobbling_enabled` выглядят устаревшими.
    
    public enum EditCodingKeys: String {
        case lastFmScrobblingEnabled
        case shuffleEnabled
        case volumePercents
        case facebookScrobblingEnabled
        case addNewTrackOnPlaylistTop
        case userMusicVisibility
        case userSocialVisibility
        case rbtDisabled
        case theme
        case promosDisabled
        case autoPlayRadio
        case syncQueueEnabled
        case childModEnabled
        case adsDisabled
        case diskEnabled
        case showDiskTracksInLibrary
    }
    
    ///User UID
    public let uid: Int
    ///Last fm scrobbling marker
    //@available(*, deprecated)
    public let lastFmScrobblingEnabled: Bool
    ///Tracks shuffle marker
    public let shuffleEnabled: Bool
    ///Audio volume in percents
    public let volumePercents: Int
    ///Last modified date
    public let modified: String
    ///Facebook scrobbling marker
    public let facebookScrobblingEnabled: Bool
    ///New inserted track in playlist will be located at the top
    public let addNewTrackOnPlaylistTop: Bool
    ///User music playlist has public access marker
    public let userMusicVisibility: String
    ///User social visibility marker
    public let userSocialVisibility: String
    ///TODO (unused)
    public let rbtDisabled: Bool
    ///UI theme
    public let theme: String
    ///Ads disabled marker
    public let promosDisabled: Bool
    ///Endless audio
    public let autoPlayRadio: Bool
    ///Device queue sync marker
    public let syncQueueEnabled: Bool
    ///Account child mode marker
    public let childModEnabled: Bool
    ///Ads disabled marker
    public let adsDisabled: Bool?
    ///TODO
    public let diskEnabled: Bool?
    ///Show local tracks in media library marker
    public let showDiskTracksInLibrary: Bool?
    
    public init(uid: Int,
                lastFmScrobblingEnabled: Bool,
                shuffleEnabled: Bool,
                volumePercents: Int,
                modified: String,
                facebookScrobblingEnabled: Bool,
                addNewTrackOnPlaylistTop: Bool,
                userMusicVisibility: String,
                userSocialVisibility: String,
                rbtDisabled: Bool,
                theme: String,
                promosDisabled: Bool,
                autoPlayRadio: Bool,
                syncQueueEnabled: Bool,
                childModEnabled: Bool,
                adsDisabled: Bool?,
                diskEnabled: Bool?,
                showDiskTracksInLibrary: Bool?) {
        self.uid = uid
        self.lastFmScrobblingEnabled = lastFmScrobblingEnabled
        self.shuffleEnabled = shuffleEnabled
        self.volumePercents = volumePercents
        self.modified = modified
        self.facebookScrobblingEnabled = facebookScrobblingEnabled
        self.addNewTrackOnPlaylistTop = addNewTrackOnPlaylistTop
        self.userMusicVisibility = userMusicVisibility
        self.userSocialVisibility = userSocialVisibility
        self.rbtDisabled = rbtDisabled
        self.theme = theme
        self.promosDisabled = promosDisabled
        self.autoPlayRadio = autoPlayRadio
        self.syncQueueEnabled = syncQueueEnabled
        self.childModEnabled = childModEnabled

        self.adsDisabled = adsDisabled
        self.diskEnabled = diskEnabled
        self.showDiskTracksInLibrary = showDiskTracksInLibrary
    }
}
