//
//  APIProvider.swift
//  Rave
//
//  Created by Developer on 24/05/2021.
//

import Foundation

///Initializes request with raw parameters
func buildRequest(basePath: String, payloadPath: String, authHeaderValue: String?, headers: [String: String], method: String, bodyData: Data?) -> URLRequest? {
    let pathEncoded = payloadPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let url: URL = URL(string: basePath + pathEncoded) else {return nil}
    
    var urlReq: URLRequest = URLRequest(url: url)
    urlReq.httpMethod = method
    
    urlReq.allHTTPHeaderFields = headers
    urlReq.allHTTPHeaderFields?["User-Agent"] = YMConstants.userAgent
    urlReq.allHTTPHeaderFields?["X-Yandex-Music-Client"] = xYmClient
    if let g_authHeaderValue = authHeaderValue {
        urlReq.allHTTPHeaderFields?["Authorization"] = g_authHeaderValue
    }
    
    urlReq.httpBody = bodyData
    
    if let g_body = urlReq.httpBody {
        urlReq.allHTTPHeaderFields?["Content-Length"] = String(g_body.count)
    }
    return urlReq
}

///Initializes request for predefined api methods
func buildRequest(for method: ApiFunction) -> URLRequest? {
    let pathEncoded = method.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let url: URL = URL(string: method.baseURL + pathEncoded) else {return nil}
    
    var urlReq: URLRequest = URLRequest(url: url)
    urlReq.httpMethod = method.method
    
    urlReq.allHTTPHeaderFields = method.headers
    urlReq.allHTTPHeaderFields?["User-Agent"] = YMConstants.userAgent
    urlReq.allHTTPHeaderFields?["X-Yandex-Music-Client"] = xYmClient
    
    if method.parameters.count > 0 {
        if (method.headers["Content-Type"] != nil) {
            urlReq.httpBody = try? JSONSerialization.data(withJSONObject: method.parameters)
        } else {
            let body = method.parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
            urlReq.httpBody = body.data(using: .utf8)
        }
    }
    
    if let g_body = urlReq.httpBody {        
        urlReq.allHTTPHeaderFields?["Content-Length"] = String(g_body.count)
    }
    return urlReq
}

func requestYMResponse(_ request: URLRequest, completion: @escaping (_ result: Result<YMResponse, YMError>) -> Void) {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            }
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": "Unknown response error"])))
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": "Parsed json is nil", "data": String(data: responseData, encoding: .utf8) ?? ""])))
            return
        }
        guard let ymResponse = YMResponse.parseFromBase(json, statusCode: statusCode) else {
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": "Couldn't parse object from json", "data": String(data: responseData, encoding: .utf8) ?? ""])))
            return
        }
        completion(.success(ymResponse))
    }
    task.resume()
}

func requestData(_ request: URLRequest, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            } else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error.debugDescription])))
            }
            return
        }
        guard (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) != false else
        {
            completion(.failure(.invalidResponseStatusCode(errCode: statusCode, description: String(data: responseData, encoding: .utf8) ?? "")))
            return
        }
        completion(.success(responseData))
    }
    task.resume()
}

func requestJson(_ request: URLRequest, completion: @escaping (_ result: Result<[String: Any], YMError>) -> Void) {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            } else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error.debugDescription])))
            }
            return
        }
        guard (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) != false else
        {
            completion(.failure(.invalidResponseStatusCode(errCode: statusCode, description: String(data: responseData, encoding: .utf8) ?? "")))
            return
        }
        do
        {
            guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                throw YMError.badResponseData(errCode: statusCode, data: ["description": "Parsed json is nil", "data": responseData])                
            }
            completion(.success(json))
        } catch {
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error, "data": responseData])))
        }
    }
    task.resume()
}
