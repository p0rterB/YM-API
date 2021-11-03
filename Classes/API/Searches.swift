//
//  Searches.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func searchByApi(token: String, text: String, noCorrect: Bool, type: String, page: Int, includeBestPlaylists: Bool, completion: @escaping (_ result: Result<Search, YMError>) -> Void)
{
    if (page < 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page index must be >=0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .search(text: text, noCorrect: noCorrect, type: type, page: page, includeBestPlaylists: includeBestPlaylists, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build search request"))); return}
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
                let searchResults: Search = try JSONDecoder().decode(Search.self, from: data)
                searchResults.page = page
                completion(.success(searchResults))
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

func getSearchSuggestionsByApi(token: String, part: String, completion: @escaping (_ result: Result<Suggestion, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .search_suggest(part: part, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build search suggestions request"))); return}
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
                let searchSuggestion: Suggestion = try JSONDecoder().decode(Suggestion.self, from: data)
                completion(.success(searchSuggestion))
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

func getSearchHistoryByApi(token: String, userId: String, completion: @escaping (_ result: Result<[SearchHistoryItem], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .search_history(userID: userId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build search history get request"))); return}
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
                let searchHistoryItems: [SearchHistoryItem] = try JSONDecoder().decode([SearchHistoryItem].self, from: data)
                completion(.success(searchHistoryItems))
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

func feedbackSearchHistoryByApi(token: String, absBlockPosition: Int, absPosition: Int, blockPosition: Int, blockType: String, clickType: String, clientNow: String, entityId: String, page: Int, position: Int, query: String, searchRequestId: String, timestamp: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .search_history_feedback(absBlockPosition: absBlockPosition, absPosition: absPosition, blockPosition: blockPosition, blockType: blockType, clickType: clickType, clientNow: clientNow, entityId: entityId, page: page, position: position, query: query, searchRequestId: searchRequestId, timestamp: timestamp, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build clear search history request"))); return}
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

func clearSearchHistoryByApi(token: String, userId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .search_history_clear(userID: userId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build clear search history request"))); return}
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
