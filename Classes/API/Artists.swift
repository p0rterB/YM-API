//
//  Artists.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func getArtistsByApi(token: String, artistIds: [String], completion: @escaping (_ result: Result<[Artist], YMError>) -> Void) {    
    guard let req: URLRequest = buildRequest(for: .artists(ids: artistIds, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build artists info request"))); return}
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
                let artists: [Artist] = try JSONDecoder().decode([Artist].self, from: data)
                completion(.success(artists))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Artist.self), description: "No data for parsing. Type mismatch (expected array)")))
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

func getArtistShortInfoByApi(token: String, artistId: String, completion: @escaping (_ result: Result<ArtistShortInfo, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .artist_short_info(artistId: artistId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build artist short info info request"))); return}
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
                let artist: ArtistShortInfo = try JSONDecoder().decode(ArtistShortInfo.self, from: data)
                completion(.success(artist))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: ArtistShortInfo.self), description: "No data for parsing")))
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

func getArtistTracksByApi(token: String, artistId: String, page: Int, pageSize: Int, completion: @escaping (_ result: Result<ArtistTracks, YMError>) -> Void) {
    if (page < 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page index must be >= 0")))
        return
    }
    if (pageSize <= 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page size must be >0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .artists_tracks(artistId: artistId, page: page, pageSize: pageSize, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build artist tracks info request"))); return}
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
                let tracks: ArtistTracks = try JSONDecoder().decode(ArtistTracks.self, from: data)
                completion(.success(tracks))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: ArtistTracks.self), description: "No data for parsing")))
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

func getArtistDirectAlbumsByApi(token: String, artistId: String, page: Int, pageSize: Int, sortBy: String, completion: @escaping (_ result: Result<ArtistAlbums, YMError>) -> Void) {
    if (page < 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page index must be >= 0")))
        return
    }
    if (pageSize <= 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page size must be >0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .artists_direct_albums(artistId: artistId, page: page, pageSize: pageSize, sortBy: sortBy, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build artist albums info request"))); return}
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
                let albums: ArtistAlbums = try JSONDecoder().decode(ArtistAlbums.self, from: data)
                completion(.success(albums))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: ArtistAlbums.self), description: "No data for parsing")))
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
