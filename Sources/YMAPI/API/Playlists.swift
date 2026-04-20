//
//  Playlists.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func getPlaylistsByApi(token: String, userId: String, playlistIds: [String], completion: @escaping (_ result: Result<[Playlist], YMError>) -> Void)
{
    if (playlistIds.count == 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Playlist IDs must be >0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .playlists(userID: userId, ids: playlistIds, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlists info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if playlistIds.count == 1, let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let playlist: Playlist = try JSONDecoder().decode(Playlist.self, from: data)
                completion(.success([playlist]))
                return
            } else if let g_dict = ymResponse.result as? [[String: Any]] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let playlists: [Playlist] = try JSONDecoder().decode([Playlist].self, from: data)
                completion(.success(playlists))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func getUserPlaylistsByApi(token: String, userId: String, completion: @escaping (_ result: Result<[Playlist], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .user_playlists(userId: userId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build user playlists info request"))); return}
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
                let playlists: [Playlist] = try JSONDecoder().decode([Playlist].self, from: data)
                completion(.success(playlists))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch (expected array)")))
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

func getPlaylistRecommendationsByApi(token: String, userId: String, playlistId: String, completion: @escaping (_ result: Result<PlaylistRecommendation, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .playlist_recommendations(userId: userId, playlistId: playlistId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build tracks info request"))); return}
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
                let playlistRecommends: PlaylistRecommendation = try JSONDecoder().decode(PlaylistRecommendation.self, from: data)
                completion(.success(playlistRecommends))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func getNewPlaylistsByApi(token: String, completion: @escaping (_ result: Result<LandingList, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .new_playlists(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build new playlists info request"))); return}
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
                let playlists: LandingList = try JSONDecoder().decode(LandingList.self, from: data)
                completion(.success(playlists))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func getTagPlaylistsByApi(token: String, tagId: String, completion: @escaping (_ result: Result<TagResult, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .tag_playlists(tagId: tagId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlists by tag info request"))); return}
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
                let playlists: TagResult = try JSONDecoder().decode(TagResult.self, from: data)
                completion(.success(playlists))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func createPlaylistByApi(token: String, ownerId: String, title: String, visibilityType: String,  completion: @escaping (_ result: Result<Playlist, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .playlist_create(ownerId: ownerId, title: title, visibilityType: visibilityType, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist create request"))); return}
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
                let playlist: Playlist = try JSONDecoder().decode(Playlist.self, from: data)
                completion(.success(playlist))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

fileprivate func playlistContentChangeByApi(token: String, ownerId: String, playlistId: String, changeOperationsJson: String, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .playlist_content_change(ownerId: ownerId, playlistId: playlistId, revision: revision, changeOperationsJson: changeOperationsJson, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist content change request"))); return}
    requestYMResponse(req) { result in
        do {
            let ymResponse = try result.get()
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: -1, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let editedPlaylist: Playlist = try JSONDecoder().decode(Playlist.self, from: data)
                completion(.success(editedPlaylist))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing")))
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func insertTrackToPlaylistByApi(token: String, ownerId: String, playlistId: String, trackId: Int, albumId: Int, index: Int, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void)
{
    insertTracksToPlaylistByApi(token: token, ownerId: ownerId, playlistId: playlistId, tracksIds: [TrackId(id: trackId, trackId: trackId, albumId: albumId, from: nil)], index: index, revision: revision, completion: completion)
}

func insertTracksToPlaylistByApi(token: String, ownerId: String, playlistId: String, tracksIds: [TrackId], index: Int, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void) {
    if (index < 0) {
        completion(.failure(.invalidInputParameter(name: "Paste position", description: "Index must be >= 0")))
        return
    }
    if (tracksIds.count == 0) {
        completion(.failure(.invalidInputParameter(name: "Tracks", description: "Tracks count must be > 0")))
        return
    }
    let commands: [PlaylistEditCommand] = [
        PlaylistEditCommand(position: index, tracksData: tracksIds)
    ]
    
    let data = (try? JSONEncoder().encode(commands)) ?? Data()
    let json = String(data: data, encoding: .utf8) ?? "{}"
    playlistContentChangeByApi(token: token, ownerId: ownerId, playlistId: playlistId, changeOperationsJson: json, revision: revision, completion: completion)
}

func importTracksIntoNewPlaylistByApi(token: String, title: String, tracksInfo: [String], completion: @escaping (_ result: Result<String, YMError>) -> Void)
{
    if (tracksInfo.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty tracks array")))
        return
    }
    
    let apiFunc: ApiFunction = .playlist_import(title: title, tracksInfo: tracksInfo, secret: token)
    var bodyStr: String = ""
    for track in tracksInfo {
        bodyStr += track + "\n"
    }
    bodyStr.removeLast()
    let bodyData = bodyStr.data(using: .utf8)
    guard let req: URLRequest = buildRequest(basePath: apiFunc.baseURL, payloadPath: apiFunc.path, authHeaderValue: nil, headers: apiFunc.headers, method: apiFunc.method, bodyData: bodyData) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist import request"))); return}
    requestYMResponse(req) { result in
        do {
            let ymResponse = try result.get()
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: -1, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any], let g_importCode = g_dict["importCode"] as? String {
                completion(.success(g_importCode))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: String.self), description: "No data for parsing")))
        } catch {
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: -1, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func getImportTracksStatusByApi(token: String, importCode: String, completion: @escaping (_ result: Result<PlaylistImportStatus, YMError>) -> Void)
{
    if (importCode.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty playlist import code")))
        return
    }
    
    guard let req: URLRequest = buildRequest(for: .playlist_import_status(importCode: importCode, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist import status check request"))); return}
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
                let importStatus: PlaylistImportStatus = try JSONDecoder().decode(PlaylistImportStatus.self, from: data)
                completion(.success(importStatus))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: PlaylistImportStatus.self), description: "No data for parsing. Type mismatch")))
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

func deleteTracksFromPlaylistByApi(token: String, ownerId: String, playlistId: String, from: Int, to: Int, revision: Int, completion: @escaping (_ result: Result<Playlist, YMError>) -> Void)
{
    let commands: [PlaylistEditCommand] = [
        PlaylistEditCommand(from: from, to: to)
    ]
    let data = (try? JSONEncoder().encode(commands)) ?? Data()
    let json = String(data: data, encoding: .utf8) ?? "{}"
    playlistContentChangeByApi(token: token, ownerId: ownerId, playlistId: playlistId, changeOperationsJson: json, revision: revision, completion: completion)
}

func editPlaylistTitleByApi(token: String, ownerId: String, playlistId: String, newTitle: String,  completion: @escaping (_ result: Result<Playlist, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .playlist_edit_title(ownerId: ownerId, playlistId: playlistId, newTitle: newTitle, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist title edit request"))); return}
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
                let playlist: Playlist = try JSONDecoder().decode(Playlist.self, from: data)
                completion(.success(playlist))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func editPlaylistVisibilityByApi(token: String, ownerId: String, playlistId: String, newVisibility: String,  completion: @escaping (_ result: Result<Playlist, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .playlist_edit_visibility(ownerId: ownerId, playlistId: playlistId, newVisibility: newVisibility, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build playlist visibility edit request"))); return}
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
                let playlist: Playlist = try JSONDecoder().decode(Playlist.self, from: data)
                completion(.success(playlist))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Playlist.self), description: "No data for parsing. Type mismatch")))
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

func deletePlaylistByApi(token: String, ownerId: String, playlistId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .playlist_delete(ownerId: ownerId, playlistId: playlistId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build tracks info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_res = ymResponse.result as? String {
                let success = g_res.lowercased().compare("ok") == .orderedSame
                completion(.success(success))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Bool.self), description: "No data for parsing. Type mismatch")))
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
