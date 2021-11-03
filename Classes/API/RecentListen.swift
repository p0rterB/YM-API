//
//  RecentListen.swift
//  YM-API
//
//  Created by Developer on 14.10.2021.
//

import Foundation

func getRecentListenListByApi(token: String, userId: String, tracksCount: Int, contextTypes: [String], contextCount: Int, completion: @escaping (_ result: Result<ListenHistory, YMError>) -> Void) {
    if (tracksCount <= 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Tracks count must be at least 1")))
        return
    }
    if (contextTypes.count == 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Count of desired contexts' types must be at least 1")))
        return
    }
    if (contextCount <= 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Result contexts count must be at least 1")))
        return
    }
    
    guard let req: URLRequest = buildRequest(for: .recent_listen(userID: userId, tracksCount: tracksCount, contextTypes: contextTypes, contextCount: contextCount, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build 'recent listen' history request"))); return}
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
                let recentListen: ListenHistory = try JSONDecoder().decode(ListenHistory.self, from: data)
                completion(.success(recentListen))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: ListenHistory.self), description: "No data for parsing. Type mismatch")))
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
