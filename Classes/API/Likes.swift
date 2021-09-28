//
//  Likes.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

fileprivate func trackLikeActionByApi(token: String, userId: String, objectIds: [String], objType: String, performRemove: Bool, completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .like_action(userdID: userId, objectsId: objectIds, objectsType: objType, performRemove: performRemove, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build like action request"))); return}
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
                guard let revision = g_dict["revision"] as? Int else {throw YMError.badResponseData(errCode: ymResponse.statusCode, data: ["description": ymResponse.result ?? [:]])}
                completion(.success(revision))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Int.self), description: "No data for parsing")))
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

fileprivate func likeActionByApi(token: String, userId: String, objectIds: [String], objType: String, performRemove: Bool, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .like_action(userdID: userId, objectsId: objectIds, objectsType: objType, performRemove: performRemove, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build like action request"))); return}
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
            completion(.failure(.invalidObject(objType: String(describing: Bool.self), description: "No data for parsing")))
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

func addLikesTrackByApi(token: String, userId: String, tracksIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
    trackLikeActionByApi(token: token, userId: userId, objectIds: tracksIds, objType: "track", performRemove: false, completion: completion)
}

func removeLikesTrackByApi(token: String, userId: String, tracksIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void)
{
    trackLikeActionByApi(token: token, userId: userId, objectIds: tracksIds, objType: "track", performRemove: true, completion: completion)
}

func addLikesArtistByApi(token: String, userId: String, artistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: artistIds, objType: "atrist", performRemove: false, completion: completion)
}

func removeLikesArtistByApi(token: String, userId: String, artistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: artistIds, objType: "atrist", performRemove: true, completion: completion)
}

func addLikesAlbumByApi(token: String, userId: String, albumIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: albumIds, objType: "album", performRemove: false, completion: completion)
}

func removeLikesAlbumByApi(token: String, userId: String, albumIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: albumIds, objType: "album", performRemove: true, completion: completion)
}

func addLikesPlaylistByApi(token: String, userId: String, playlistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: playlistIds, objType: "playlist", performRemove: false, completion: completion)
}

func removeLikesPlaylistByApi(token: String, userId: String, playlistIds: [String], completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    likeActionByApi(token: token, userId: userId, objectIds: playlistIds, objType: "playlist", performRemove: true, completion: completion)
}

fileprivate func trackDislikeActionByApi(token: String, userId: String, objectIds: [String], objType: String, performRemove: Bool, completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .dislike_action(userdID: userId, objectsId: objectIds, objectsType: objType, performRemove: performRemove, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build dislike action request"))); return}
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
                guard let revision = g_dict["revision"] as? Int else {throw YMError.badResponseData(errCode: ymResponse.statusCode, data: ["description": ymResponse.result ?? [:]])}
                completion(.success(revision))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Int.self), description: "No data for parsing")))
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

func addDislikesTrackByApi(token: String, userId: String, tracksIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void) {
    trackDislikeActionByApi(token: token, userId: userId, objectIds: tracksIds, objType: "track", performRemove: false, completion: completion)
}

func removeDislikesTrackByApi(token: String, userId: String, tracksIds: [String], completion: @escaping (_ result: Result<Int, YMError>) -> Void)
{
    trackDislikeActionByApi(token: token, userId: userId, objectIds: tracksIds, objType: "track", performRemove: true, completion: completion)
}

func getLikedTracksByApi(token: String, userId: String, modifiedRevision: Int?, completion: @escaping (_ result: Result<LikeLibrary, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .liked_tracks(userId: userId, modifiedRevision: modifiedRevision, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build liked tracks list request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any], let g_library = g_dict["library"] as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_library)
                let likes: LikeLibrary = try JSONDecoder().decode(LikeLibrary.self, from: data)
                completion(.success(likes))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LikeLibrary.self), description: "No data for parsing")))
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

func getDislikedTracksByApi(token: String, userId: String, modifiedRevision: Int?, completion: @escaping (_ result: Result<LikeLibrary, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .disliked_tracks(userId: userId, modifiedRevision: modifiedRevision, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build liked tracks list request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any], let g_library = g_dict["library"] as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_library)
                let dislikes: LikeLibrary = try JSONDecoder().decode(LikeLibrary.self, from: data)
                completion(.success(dislikes))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LikeLibrary.self), description: "No data for parsing")))
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

func getLikedArtistsByApi(token: String, userId: String, likeTs: Bool, completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .liked_artists(userId: userId, likesTs: likeTs, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build liked artists list request"))); return}
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
                let likes: [LikeObject] = try JSONDecoder().decode([LikeObject].self, from: data)
                completion(.success(likes))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LikeObject.self), description: "No data for parsing. Type mismatch (expected array)")))
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

func getLikedAlbumsByApi(token: String, userId: String, rich: Bool, completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .liked_albums(userId: userId, rich: rich, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build liked albums list request"))); return}
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
                let likes: [LikeObject] = try JSONDecoder().decode([LikeObject].self, from: data)
                completion(.success(likes))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LikeObject.self), description: "No data for parsing. Type mismatch (expected array)")))
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

func getLikedPlaylistsByApi(token: String, userId: String, completion: @escaping (_ result: Result<[LikeObject], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .liked_playlists(userId: userId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build liked playlists list request"))); return}
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
                let likes: [LikeObject] = try JSONDecoder().decode([LikeObject].self, from: data)
                completion(.success(likes))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: LikeObject.self), description: "No data for parsing. Type mismatch (expected array)")))
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
