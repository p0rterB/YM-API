//
//  Labels.swift
//  YM-API
//
//  Created by Developer on 15.10.2021.
//

import Foundation

fileprivate func getLabelDataByApi(token: String, labelID: String, dataType: String, page: Int, completion: @escaping (_ result: Result<MusicLabel, YMError>) -> Void) {
    if (page < 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Page index must be >=0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .label_data(labelID: labelID, dataType: dataType, page: page, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build label data request"))); return}
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
                let label: MusicLabel = try JSONDecoder().decode(MusicLabel.self, from: data)
                completion(.success(label))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: MusicLabel.self), description: "No data for parsing")))
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

func getLabelAlbumsByApi(token: String, labelID: String, page: Int, completion: @escaping (_ result: Result<MusicLabel, YMError>) -> Void) {
    getLabelDataByApi(token: token, labelID: labelID, dataType: "albums", page: page, completion: completion)
}

func getLabelArtistsByApi(token: String, labelID: String, page: Int, completion: @escaping (_ result: Result<MusicLabel, YMError>) -> Void) {
    getLabelDataByApi(token: token, labelID: labelID, dataType: "artists", page: page, completion: completion)
}
