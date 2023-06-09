/*
 Localisator.swift
 Rave

 Created by Developer on 21.05.2021.
 Copyright © 2021 Zeit. All rights reserved.
*/

import Foundation

/*Для добавления нового языка:
 1) Добавить новый case {language_id} = {Название языка} в AvailableLocalizations
 2) Связать идентификатор Locale с новым языком в var locale: Locale и в func getLocalizationByLocale
 ! Имена файлов локализаций (*.strings) должны соответствовать принятым Apple идентификаторам (весь перечень внизу)
*/

enum AvailableLocalizations: String, Codable, CaseIterable
{
    //Здесь будет имя языка (можно вставить любое имя для конкретного языка)
    case english = "English"
    case russian = "Русский"
}

extension AvailableLocalizations
{
    static func getAllKeys() -> [String]
    {
        var res: [String] = []
        for obj in allCases
        {
            res.append(obj.rawValue)
        }
        return res
    }
    
    var locale: Locale
    {
        get
        {
            switch self
            {
            //Здесь надо связать новую локаль с моделью локализации iOS (идентификатор строго фиксирован для каждого языка и отражает также имя файла с локализациями)
            case .russian: return Locale(identifier: "ru_RU")
            case .english: return Locale(identifier: "en_GB")
            }
        }
    }
    
    static func getLocalizationByLocale(_ locale: Locale) -> AvailableLocalizations?
    {
        //Здесь надо связать модель локали iOS с моделью локали приложения (обратный процесс прошлому), идентификаторы соответствуют стандартным обозначениям Apple
        if (locale.identifier.contains("ru-"))
        {
            return .russian
        }
        if (locale.identifier.contains("en-"))
        {
            return .english
        }
        return nil
    }
    
    static func getLocalicationByLocaleIdentifier(_ locale_id: String) -> AvailableLocalizations?
    {
        //Здесь надо связать идентификатор модели локали iOS с моделью локали приложения (второй вариант исполнения для прошлого)
        if (locale_id.contains("ru-"))
        {
            return .russian
        }
        if (locale_id.contains("en-"))
        {
            return .english
        }
        return nil
    }
}

enum LocalizationKeys: String
{
    case auth_login_title
    case auth_login_hint
    case auth_enter_password
    case auth_empty_login_error
    case auth_empty_pass_error
    case auth_generating_access_token
    
    case landing_title
    case landing_personal_playlists_title
    
    case playlist_tracks_count
    case playlist_favourite_title
    case playlist_updated
    
    case track_option_like
    case track_option_download
    case track_option_play_next
    case track_option_add_to_queue
    case track_option_dislike
    case track_option_share
    
    case radio_title
    case radio_recommended_stations

    case favourite_title
    
    case my_playlists_title
    case my_playlists_created_title
    case my_playlists_liked_title
    
    case profile_title
    case profile_logout_hint
    case profile_traffic_economy
    case profile_traffic_economy_hint

    case search_title
    
    case player_not_playing
    case player_unknown_track_title
    case player_unknown_track_artists
    
    case general_register
    case general_password
    case general_error
    case general_next
    case general_restart
    case general_today
    case general_yesterday
    case general_download
    case general_copy
    case general_remove
    case general_tracks
    case general_albums
    case general_artists
    case general_playlists
    case general_podcasts
    case general_downloaded_tracks
    case general_settings
    case general_about
    case general_version
    case general_yes
    case general_no
}

extension LocalizationKeys
{
    ///Returns localized string value for default (system-level) localization
    func localizedString() -> String
    {
        if let g_supported_locale = AvailableLocalizations.getLocalizationByLocale(Locale.current)
        {
            return localizedString(for: g_supported_locale)
        }
        return "System localization isn't supported in this app"
    }
    
    ///Returns localized string value for user-defined localization
    func localizedString(for locale: AvailableLocalizations) -> String
    {
        let tbl_name: String = locale.locale.identifier
        return NSLocalizedString(self.rawValue, tableName: tbl_name, bundle: Bundle.main, value: "No localized value", comment: "")
    }
}
