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
        case .auth_init_session: return "https://passport.yandex.ru/"
        case .auth_generate_x_token: return "https://mobileproxy.passport.yandex.net/"
        case .auth_generate_ym_token: return "https://mobileproxy.passport.yandex.net/"
        case .account_avatar: return "https://mobileproxy.passport.yandex.net/"
        default: return YMConstants.apiBasePath
        }
    }
}
