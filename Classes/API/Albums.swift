//
//  Albums.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation


func getAlbumsByApi(token: String, albumIds: [String], completion: @escaping (_ result: Result<[Album], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .albums(ids: albumIds, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build albums info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [[String: Any]] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let albums: [Album] = try JSONDecoder().decode([Album].self, from: data)
                completion(.success(albums))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Album.self), description: "No data for parsing. Type mismatch (expected array)")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getNewAlbumsByApi(token: String, completion: @escaping (_ result: Result<LandingList, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .new_albums(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build new albums info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let albums: LandingList = try JSONDecoder().decode(LandingList.self, from: data)
                completion(.success(albums))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LandingList.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getAlbumWithTracksByApi(token: String, albumId: String, completion: @escaping (_ result: Result<Album, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .album_with_tracks(albumId: albumId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build album with tracks info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let album: Album = try JSONDecoder().decode(Album.self, from: data)
                completion(.success(album))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Album.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}
