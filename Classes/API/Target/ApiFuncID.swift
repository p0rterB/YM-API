//
//  ApiFuncID.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
enum ApiFunction {
    //General
    case download(fullPath: String)
    //Reg,Auth
    case auth_init(login: String, lang: ApiLanguage, appId: String, uuid: String, appVersionName: String, manufacturer: String, deviceId: String, deviceName: String, platform: String, model: String)
    case auth_pass(trackId: String, pass: String, captchaAnswer: String?, captchaKey: String?)
    case auth_generate_token(xToken: String, appId: String, appVersionName: String, deviceId: String, manufacturer: String, deviceName: String, platform: String, model: String)
    case auth_legacy(login: String, pass: String, lang: ApiLanguage, captchaAnswer: String?, captchaKey: String?)
    //Account
    case account_status(secret: String)
    case account_avatar(size: Int, secret: String)
    case rotor_account_status(secret: String)
    case account_experiments(secret: String)
    case account_settings(secret: String)
    case account_settings_edit(secret: String, values: [String: Any])
    case purchase_suggestions(secret: String)
    case permission_alerts(secret: String)
    case consume_promo_code(lang: ApiLanguage, secret: String, code: String)
    //Player
    case feed(secret: String)
    case play(trackId: String, albumId: String, playlistId: String, from: String, fromCache: Bool, playId: String, userID: String, trackLength: Int, totalPlayed: Int, endPositionPoints: Int, secret: String)
    case after_track(nextTrackId: String, contextItem: String, prevTrackId: String, context: String, type: String, from: String, secret: String)//Получение рекламы или шота от Алисы после трека. context = playlist, contextItem = {OWNER_PLAYLIST}:{ID_PLAYLIST}; types = shot или ad; Плейлист с Алисой имеет владельца с `id = 940441070`.
    case queue(queueId: String, secret: String)
    case queue_create(queueJson: [String: Any], device: String, secret: String)
    case queue_update_position(queueId: String, newIndex: Int, device: String, secret: String)
    case queues_list(device: String, secret: String)
    //Tracks
    case tracks(ids: [String], positions: Bool, secret: String)
    case tracks_similar(trackId: String, secret: String)
    case track_download_info(trackId: String, secret: String)
    case track_supplement(trackId: String, secret: String)
    //Artists
    case artists(ids: [String], secret: String)
    case artist_short_info(artistId: String, secret: String)
    case artists_tracks(artistId: String, page: Int, pageSize: Int, secret: String)
    case artists_direct_albums(artistId: String, page: Int, pageSize: Int, sortBy: String, secret: String)
    //Albums
    case albums(ids: [String], secret: String)
    case new_albums(secret: String)
    case album_with_tracks(albumId: String, secret: String)
    //Playlists
    case playlists(userID: String, ids: [String], secret: String)
    case user_playlists(userId: String, secret: String)
    case playlist_recommendations(userId: String, playlistId: String, secret: String)
    case new_playlists(secret: String)
    case tag_playlists(tagId: String, secret: String)
    case playlist_create(ownerId: String, title: String, visibilityType: String, secret: String)
    case playlist_edit_title(ownerId: String, playlistId: String, newTitle: String, secret: String)
    case playlist_edit_visibility(ownerId: String, playlistId: String, newVisibility: String, secret: String)
    case playlist_content_change(ownerId: String, playlistId: String, revision: Int, changeOperationsJson: String, secret: String)
    case playlist_delete(ownerId: String, playlistId: String, secret: String)
    //Labels
    case label_data(labelID: String, dataType: String, page: Int, secret: String)
    //Search
    case search(text: String, noCorrect: Bool, type: String, page: Int, includeBestPlaylists: Bool, secret: String)//type_`: `all`, `artist`, `user`, `album`, `playlist`, `track`, `podcast`, `podcast_episode`
    case search_suggest(part: String, secret: String)
    case search_history(userID: String, secret: String)
    case search_history_feedback(absBlockPosition: Int, absPosition: Int, blockPosition: Int, blockType: String, clickType: String, clientNow: String, entityId: String, page: Int, position: Int, query: String, searchRequestId: String, timestamp: String, secret: String)
    case search_history_clear(userID: String, secret: String)
    //Recent listen
    case recent_listen(userID: String, tracksCount: Int, contextTypes: [String], contextCount: Int, secret: String)
    //Liked
    case like_action(userdID: String, objectsId: [String], objectsType: String, performRemove: Bool, secret: String)
    case dislike_action(userdID: String, objectsId: [String], objectsType: String, performRemove: Bool, secret: String)
    case liked_tracks(userId: String, modifiedRevision: Int?, secret: String)
    case disliked_tracks(userId: String, modifiedRevision: Int?, secret: String)
    case liked_albums(userId: String, rich: Bool, secret: String)
    case liked_artists(userId: String, likesTs: Bool, secret: String)
    case liked_playlists(userId: String, secret: String)
    
    case landing(blocks: [String], secret: String)
    case promotions(feedBlockID: String, secret: String)
    case chart(option: String, secret: String)
    case podcasts(secret: String)
    case genres(secret: String)
    //Radio
    case stations_dashboard(secret: String)
    case stations_list(language: String, secret: String)
    case station_info(stationId: String, secret: String)
    case station_tracks(stationId: String, settings2: Bool, lastTrackId: String, secret: String)
    case station_feedback_action(stationId: String, actionType: String, timestamp8601: String, fromInfo: String, tracksBatchId: String, playedSeconds: Double, trackId: String, secret: String)
    case station_settings(stationId: String, language: String, moodEnergy: String, diversity: String, type: String, secret: String)
}
