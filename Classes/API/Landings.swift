//
//  Landings.swift
//  YM-API
//
//  Created by Developer on 01.09.2021.
//

import Foundation

func getLandingByApi(token: String, blocks: [String], completion: @escaping (_ result: Result<Landing, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .landing(blocks: blocks, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build chart info request"))); return}
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
                let landing: Landing = try JSONDecoder().decode(Landing.self, from: data)
                completion(.success(landing))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Landing.self), description: "No data for parsing")))
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

func getChartByApi(token: String, option: String, completion: @escaping (_ result: Result<ChartList, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .chart(option: option, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build chart info request"))); return}
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
                let chart: ChartList = try JSONDecoder().decode(ChartList.self, from: data)
                completion(.success(chart))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: ChartList.self), description: "No data for parsing")))
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

func getPodcastsByApi(token: String, completion: @escaping (_ result: Result<LandingList, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .podcasts(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build podcasts info request"))); return}
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
                let podcasts: LandingList = try JSONDecoder().decode(LandingList.self, from: data)
                completion(.success(podcasts))
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


func getGenresByApi(token: String, completion: @escaping (_ result: Result<[Genre], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .genres(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build music genres info request"))); return}
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
                let genres: [Genre] = try JSONDecoder().decode([Genre].self, from: data)
                completion(.success(genres))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Genre.self), description: "No data for parsing. Type mismatch (expected array)")))
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
