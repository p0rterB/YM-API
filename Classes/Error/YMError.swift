//
//  YMBaseException.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents general exceptions of API work
public enum YMError: Error
{
    case general(errCode: Int, data: [String: Any])
    case badRequest(errCode: Int, description: String)
    case requestTimeout(errCode: Int, description: String)
    case badResponseData(errCode: Int, data: [String: Any])
    case invalidResponseStatusCode(errCode: Int, description: String)
    case captchaRequired(errCode: Int, data: [String: Any])
    case wrongCaptcha(errCode: Int, description: String)
    case invalidInputParameter(name: String, description: String)
    case invalidObject(objType: String, description: String)
    case invalidToken(description: String)
    case invalidBitrate(description: String)
    case trackDownloadInfoNotExists(description: String)
    case trackDownloadLinkDead(description: String)
}
