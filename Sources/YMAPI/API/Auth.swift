//
//  Auth.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

func generateXTokenByAmApi(xClientId: String, xClientSecret: String, yaClientCookie: String, trackId: String, manufacturer: String, model: String, platform: String, amVersionName: String, appId: String, appVersionName: String, deviceId: String, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
    if (trackId.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty AM track ID")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_generate_x_token(xClientId: xClientId, xClientSecret: xClientSecret, yaClientCookie: yaClientCookie, trackId: trackId, manufacturer: manufacturer, model: model, platform: platform, amVersionName: amVersionName, appId: appId, appVersionName: appVersionName, deviceId: deviceId)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build generate x token request")))
        return
    }
    requestJson(req) { result in
        do {
            let json = try result.get()
            let token = json["access_token"] as? String ?? ""
            let expiresIn = json["expires_in"] as? Int ?? 0
            let tokenType = json["token_type"] as? String ?? ""
            let dict: [ApiAuthKeys: String] = [.access_token: token, .expires_in: String(expiresIn), .token_type: tokenType]
            completion(.success(dict))
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func generateYMTokenByApi(xToken: String, ymClientId: String, ymClientSecret: String, appId: String, amVersionName: String, appVersionName: String, manufacturer: String, deviceId: String, platform: String, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
    if (xToken.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty X Token")))
    }
    guard let req: URLRequest = buildRequest(for: .auth_generate_ym_token(xToken: xToken, ymClientId: ymClientId, ymClientSecret: ymClientSecret, appId: appId, amVersionName: amVersionName, appVersionName: appVersionName, deviceId: deviceId, manufacturer: manufacturer, platform: platform)) else {
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
    if (token.contains(" ")) {
        throw YMError.invalidToken(description: token + "hasn't passed validation (count " + String(token.count) + ")")
    }
}
