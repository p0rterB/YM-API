//
//  Queues.swift
//  YM-API
//
//  Created by Developer on 01.09.2021.
//

import Foundation

func getQueueDataByApi(token: String, queueId: String, completion: @escaping (_ result: Result<Queue, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .queue(queueId: queueId, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build queue info request"))); return}
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
                let queue: Queue = try JSONDecoder().decode(Queue.self, from: data)
                completion(.success(queue))
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

func getQueuesListByApi(token: String, device: String, completion: @escaping (_ result: Result<QueueList, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .queues_list(device: device, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build device queues list info request"))); return}
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
                let queues: QueueList = try JSONDecoder().decode(QueueList.self, from: data)
                completion(.success(queues))
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

func setQueueCurrentIndexByApi(token: String, queueId: String, newIndex: Int, device: String, completion: @escaping (_ result: Result<Bool, YMError>) -> Void)
{
    if (newIndex < 0) {
        completion(.failure(.badRequest(errCode: -1, description: "Queue index must be >= 0")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .queue_update_position(queueId: queueId, newIndex: newIndex, device: device, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build radio station settimgs edit request"))); return}
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

func createQueueByApi(token: String, queue: Queue, device: String, completion: @escaping (_ result: Result<Queue, YMError>) -> Void)
{
    guard let queueData = try? JSONEncoder().encode(queue) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to encode queue object on json")))
        return
    }
    guard let json = try? JSONSerialization.jsonObject(with: queueData, options: []) as? [String: AnyObject] else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to encode queue object on json")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .queue_create(queueJson: json, device: device, secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build queue creator request"))); return}
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
                let id = g_dict["id"] as? String ?? ""
                let modified = g_dict["modified"] as? String ?? ""
                queue.id = id
                queue.modified = modified
                completion(.success(queue))
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
