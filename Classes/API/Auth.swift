//
//  Auth.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Authienticate by username and password
func authFromCredentialsByApi(login: String, password: String, lang: ApiLanguage, captchaAnswer: String?, captchaKey: String?, captchaCallback: CaptchaResponse?, completion: @escaping (_ result: Result<[ApiAuthKeys: String], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .auth_pass(login: login, pass: password, lang: lang, captchaAnswer: captchaAnswer, captchaKey: captchaKey)) else {
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

fileprivate func validateToken(_ token: String) throws {
    if (token.contains(" ") || token.count != 39) {
        throw YMError.invalidToken(description: token + "hasn't passed validation (count " + String(token.count) + ")")
    }
}
