//
//  Tracks.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func getTracksByApi(token: String, trackIds: [String], positions: Bool, completion: @escaping (_ result: Result<[Track], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .tracks(ids: trackIds, positions: positions, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build tracks info request"))); return}
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
                let tracks: [Track] = try JSONDecoder().decode([Track].self, from: data)
                completion(.success(tracks))
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

func getTrackDownloadLinkByApi(downloadInfoUrl: String, completion: @escaping (_ result: Result<String, YMError>) -> Void)
{
    guard let url: URL = URL(string: downloadInfoUrl) else {completion(.failure(.badRequest(errCode: -1, description: "Incorrect track download info url"))); return}
    
    var urlReq: URLRequest = URLRequest(url: url)
    urlReq.httpMethod = "GET"
    requestData(urlReq) { result in
        do
        {
            let g_resultData = try result.get()
            let xmlProcessor = XmlUtil(xml_data: g_resultData) { (dict) in
                var host: String = ""
                var path: String = ""
                var ts: String = ""
                var s: String = ""
                var sign: String = ""
                for key in dict.keys {
                    if (key.compare("host") == .orderedSame) {
                        host = dict[key] as? String ?? ""
                        continue
                    }
                    if (key.compare("path") == .orderedSame) {
                        path = dict[key] as? String ?? ""
                        continue
                    }
                    if (key.compare("ts") == .orderedSame) {
                        ts = dict[key] as? String ?? ""
                        continue
                    }
                    if (key.compare("s") == .orderedSame) {
                        s = dict[key] as? String ?? ""
                        continue
                    }
                    if (host != "" && path != "" && ts != "" && s != "") {
                        break
                    }
                }
                sign = CryptoUtil.md5String(string: "XGRlBW9FXlekgbPrRHuSiA" + path + s)
                completion(.success("https://" + host + "/get-mp3/" + sign + "/" + ts + path))
            }
            xmlProcessor.parse()
        } catch {
            completion(.failure(.badResponseData(errCode: -1, data: ["description": error])))
        }
    }
}

func getSimilarTracksByApi(token: String, trackId: String, completion: @escaping (_ result: Result<TracksSimilar, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .tracks_similar(trackId: trackId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build similar tracks get request"))); return}
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
                let similar: TracksSimilar = try JSONDecoder().decode(TracksSimilar.self, from: data)
                completion(.success(similar))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Album.self), description: "No data for parsing. Type mismatch")))
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

func getTrackDownloadInfoByApi(token: String, trackId: String, completion: @escaping (_ result: Result<[DownloadInfo], YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .track_download_info(trackId: trackId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build track donwload info request"))); return}
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
                let tracks: [DownloadInfo] = try JSONDecoder().decode([DownloadInfo].self, from: data)
                completion(.success(tracks))
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

func getTrackSupplementByApi(token: String, trackId: String, completion: @escaping (_ result: Result<Supplement, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .track_supplement(trackId: trackId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build track supplement info request"))); return}
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
                let trackSupplement: Supplement = try JSONDecoder().decode(Supplement.self, from: data)
                completion(.success(trackSupplement))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Album.self), description: "No data for parsing. Type mismatch")))
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
