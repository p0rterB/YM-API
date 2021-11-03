//
//  Auth.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

func authFromCredentialsByApi(login: String, password: String, lang: ApiLanguage, captchaAnswer: String?, captchaKey: String?, captchaCallback: CaptchaResponse?, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
    if (login.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty login")))
    }
    if (password.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty password")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_legacy(login: login, pass: password, lang: lang, captchaAnswer: captchaAnswer, captchaKey: captchaKey)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build authorize request")))
        return
    }
    requestJson(req) {
        result in
        do
        {
            let json = try result.get()
            let token = json["access_token"] as? String ?? ""
            try validateToken(token)
            let expiresIn = json["expires_in"] as? Int ?? 0
            let tokenType = json["token_type"] as? String ?? ""
            let uid = json["uid"] as? Int ?? -1
            let dict: [ApiAuthKeys: String] = [.access_token: token, .expires_in: String(expiresIn), .token_type: tokenType, .uid: String(uid)]
            completion(.success(dict))
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func initializeAuthorizationByApi(login: String, lang: ApiLanguage, appId: String, uuid: String, appVersionName: String, manufacturer: String, deviceId: String, deviceName: String, platform: String, model: String, completion: @escaping (_ result: Result<String, YMError>) -> Void) {
    if (login.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty login")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_init(login: login, lang: lang, appId: appId, uuid: uuid, appVersionName: appVersionName, manufacturer: manufacturer, deviceId: deviceId, deviceName: deviceName, platform: platform, model: model)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build authorize request")))
        return
    }
    requestJson(req) {
        result in
        do {
            let json = try result.get()
            if let g_trackId = json["track_id"] as? String {
                if (json["status"] as? String == "ok") {
                    completion(.success(g_trackId))
                } else {
                    let errors = json["errors"] as? [String] ?? []
                    var errDesc = errors.joined(separator: ";")
                    if (errDesc.isEmpty) {
                        errDesc = "User not exists with login " + login
                    }
                    completion(.failure(.userNotExists(errCode: -1, description: errDesc)))
                }
                return
            }
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func authByPasswordByApi(trackId: String, password: String, captchaAnswer: String?, captchaKey: String?, captchaCallback: CaptchaResponse?, completion: @escaping (_ result: Result<XPassportObj, YMError>) -> Void) {
    if (password.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty password")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_pass(trackId: trackId, pass: password, captchaAnswer: captchaAnswer, captchaKey: captchaKey)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build authorize request")))
        return
    }
    requestJson(req) {
        result in
        do {
            let json = try result.get()
            let data = try JSONSerialization.data(withJSONObject: json)
            let xAuth: XPassportObj = try JSONDecoder().decode(XPassportObj.self, from: data)
            completion(.success(xAuth))            
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func generateYMTokenByApi(xToken: String, appId: String, uuid: String, appVersionName: String, manufacturer: String, deviceId: String, deviceName: String, platform: String, model: String, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
    if (xToken.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty X Token")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_generate_token(xToken: xToken, appId: appId, appVersionName: appVersionName, deviceId: deviceId, manufacturer: manufacturer, deviceName: deviceName, platform: platform, model: model)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build authorize request")))
        return
    }
    requestJson(req) { result in
        do {
            let json = try result.get()
            let token = json["access_token"] as? String ?? ""
            try validateToken(token)
            let expiresIn = json["expires_in"] as? Int ?? 0
            let tokenType = json["token_type"] as? String ?? ""
            let uid = json["uid"] as? Int ?? -1
            let dict: [ApiAuthKeys: String] = [.access_token: token, .expires_in: String(expiresIn), .token_type: tokenType, .uid: String(uid)]
            completion(.success(dict))
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

fileprivate func validateToken(_ token: String) throws {
    if (token.contains(" ") || token.count != 39) {
        throw YMError.invalidToken(description: token + "hasn't passed validation (count " + String(token.count) + ")")
    }
}
