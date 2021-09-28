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
        case .auth_pass: return "https://oauth.yandex.ru/"
        default: return "https://api.music.yandex.net/"
        }
    }
}
