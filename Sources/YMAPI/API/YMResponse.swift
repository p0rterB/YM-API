//
//  Response.swift
//  YM-API
//
//  Created by Developer on 02.09.2021.
//

import Foundation

///Represents parsed response from back-end
public class YMResponse {
    
    enum CodingKeys: CodingKey {
        case invocationInfo
        case result
        case error
    }
    
    ///Response status code
    public let statusCode: Int
    ///Back-end response metada
    public let invocationInfo: YMInvocationInfo
    ///Response payload (can be dictoionary or array)
    public let result: Any?
    ///Response error data
    public let error: ResponseError?
    
    public var isSuccessResponse: Bool {get {return statusCode >= 200 && statusCode < 300}}
    
    public init(statusCode: Int, invocationInfo: YMInvocationInfo, result: Any?, error: ResponseError?) {
        self.statusCode = statusCode
        self.invocationInfo = invocationInfo
        self.result = result
        self.error = error
    }
    
    static func parseFromBase(_ base: [String: Any], statusCode: Int) -> YMResponse? {
        var invocationInfo: YMInvocationInfo?
        var error: ResponseError?

        if let g_dict = base[CodingKeys.invocationInfo.stringValue] {
            if let g_data = try? JSONSerialization.data(withJSONObject: g_dict) {
                invocationInfo = try? JSONDecoder().decode(YMInvocationInfo.self, from: g_data)
            }
        }
                
        if let g_dict = base[CodingKeys.error.stringValue] {
            if let g_data = try? JSONSerialization.data(withJSONObject: g_dict) {
                error = try? JSONDecoder().decode(ResponseError.self, from: g_data)
            }
        }
        
        let result = base[CodingKeys.result.stringValue]
        
        if let g_invocation = invocationInfo {
            return YMResponse(statusCode: statusCode, invocationInfo: g_invocation, result: result, error: error)
        }
        return nil
    }
}
