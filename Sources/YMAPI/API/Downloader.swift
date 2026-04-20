//
//  Downloader.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Downloads any resource
func download(fullPath: String, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .download(fullPath: fullPath)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build downloader request"))); return}
    requestData(req, completion: completion)
}

func downloadAccountAvatarByApi(xToken: String, size: Int, completion: @escaping (_ result: Result<XPassportObj, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .account_avatar(size: size, secret: xToken)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build ava downloader request"))); return}
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
