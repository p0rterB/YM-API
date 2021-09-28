//
//  Player.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func getFeedByApi(token: String, completion: @escaping (_ result: Result<Feed, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .feed(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build feed info request"))); return}
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
                let feed: Feed = try JSONDecoder().decode(Feed.self, from: data)
                completion(.success(feed))
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

func sendPlayAudioStateByApi(token: String, trackId: String, albumId: String, playlistId: String, from: String, fromCache: Bool, playId: String, userID: String, trackLength: Int, totalPlayed: Int, endPositionPoints: Int, completion: @escaping (_ result: Result<String, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .play(trackId: trackId, albumId: albumId, playlistId: playlistId, from: from, fromCache: fromCache, playId: playId, userID: userID, trackLength: trackLength, totalPlayed: totalPlayed, endPositionPoints: endPositionPoints, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build play audio state request"))); return}
    requestYMResponse(req) { result in
        //TODO
    }
}

func getAfterTrackShot(token: String, nextTrackId: String, contextItem: String, prevTrackId: String, context: String, type: String, from: String, completion: @escaping (_ result: Result<String, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .after_track(nextTrackId: nextTrackId, contextItem: contextItem, prevTrackId: prevTrackId, context: context, type: type, from: from, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build after track event request"))); return}
    requestYMResponse(req) { result in
        //TODO
    }
}

/*
 @log
 def feed_wizard_is_passed(self, timeout: Union[int, float] = None, *args, **kwargs) -> bool:
     url = f'{self.base_url}/feed/wizard/is-passed'

     result = self._request.get(url, timeout=timeout, *args, **kwargs)

     return result.get('is_wizard_passed') or False
 */
