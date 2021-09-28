//
//  Rotors.swift
//  YM-API
//
//  Created by Developer on 26.08.2021.
//

import Foundation

func getStationsDashboardByApi(token: String, completion: @escaping (_ result: Result<RadioDashboard, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .stations_dashboard(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio stations dashboard request"))); return}
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
                let dashboard: RadioDashboard = try JSONDecoder().decode(RadioDashboard.self, from: data)
                completion(.success(dashboard))
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

func getRadioStationsListByApi(token: String, language: ApiLanguage, completion: @escaping (_ result: Result<[StationResult], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .stations_list(language: language.rawValue, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio stations list request"))); return}
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
                let stations: [StationResult] = try JSONDecoder().decode([StationResult].self, from: data)
                completion(.success(stations))
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

func getRadioStationInfoByApi(token: String, stationId: String, completion: @escaping (_ result: Result<[StationResult], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .station_info(stationId: stationId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio station info request"))); return}
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
                let stations: [StationResult] = try JSONDecoder().decode([StationResult].self, from: data)
                completion(.success(stations))
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

func getRadioStationTracksBatchByApi(token: String, stationId: String, settings2: Bool, lastTrackId: String?, completion: @escaping (_ result: Result<StationTracksResult, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .station_tracks(stationId: stationId, settings2: settings2, lastTrackId: lastTrackId ?? "", secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio station tracks info request"))); return}
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
                let tracks: StationTracksResult = try JSONDecoder().decode(StationTracksResult.self, from: data)
                completion(.success(tracks))
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

func setRadioStationSettingsByApi(token: String, stationId: String, language: StationPreferredLanguageType, moodEnergy: StationMoodType, diversity: StationDiversityType, type: StationType, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .station_settings(stationId: stationId, language: language.rawValue, moodEnergy: moodEnergy.rawValue, diversity: diversity.rawValue, type: type.rawValue, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio station settings edit request"))); return}
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

fileprivate func radioStationActionByApi(token: String, stationId: String, actionType: String, timestamp8601: String, fromInfo: String, tracksBatchId: String, trackId: String, playedSeconds: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .station_feedback_action(stationId: stationId, actionType: actionType, timestamp8601: timestamp8601, fromInfo: fromInfo, tracksBatchId: tracksBatchId, playedSeconds: playedSeconds, trackId: trackId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio station event request"))); return}
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

func radioStationStartedByApi(token: String, stationId: String, timestamp8601: String, fromInfo: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    radioStationActionByApi(token: token, stationId: stationId, actionType: "radioStarted", timestamp8601: timestamp8601, fromInfo: fromInfo, tracksBatchId: "", trackId: "", playedSeconds: -1, completion: completion)
}

func radioStationTrackStartedByApi(token: String, stationId: String, timestamp8601: String, tracksBatchId: String, trackId: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    radioStationActionByApi(token: token, stationId: stationId, actionType: "trackStarted", timestamp8601: timestamp8601, fromInfo: "", tracksBatchId: tracksBatchId, trackId: trackId, playedSeconds: -1, completion: completion)
}

func radioStationTrackFinishedByApi(token: String, stationId: String, timestamp8601: String, tracksBatchId: String, trackId: String, playedSeconds: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    radioStationActionByApi(token: token, stationId: stationId, actionType: "trackFinished", timestamp8601: timestamp8601, fromInfo: "", tracksBatchId: tracksBatchId, trackId: trackId, playedSeconds: playedSeconds, completion: completion)
}

func radioStationTrackSkippedByApi(token: String, stationId: String, timestamp8601: String, trackId: String, playedSeconds: Double, completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
    radioStationActionByApi(token: token, stationId: stationId, actionType: "skip", timestamp8601: timestamp8601, fromInfo: "", tracksBatchId: "", trackId: trackId, playedSeconds: playedSeconds, completion: completion)
}
