//
//  Downloader.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Downloads any resource
func download(fullPath: String, completion: @escaping (_ result: Result<Data, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .download(fullPath: fullPath)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build downloader request"))); return}
    requestData(req, completion: completion)
}
