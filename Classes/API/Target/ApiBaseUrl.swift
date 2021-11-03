//
//  ApiBaseUrl.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//
extension ApiFunction {
    
    var baseURL: String {
        switch self {
        case .download(let path): return path
        case .auth_legacy: return "https://oauth.yandex.ru/"
        case .auth_init: return "https://mobileproxy.passport.yandex.net/"
        case .auth_pass: return "https://mobileproxy.passport.yandex.net/"
        case .auth_generate_token: return "https://mobileproxy.passport.yandex.net/"
        case .account_avatar: return "https://mobileproxy.passport.yandex.net/"
        default: return "https://api.music.yandex.net/"
        }
    }
}
