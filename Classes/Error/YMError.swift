//
//  YMBaseException.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

///Represents general exceptions of API work
public enum YMError: Error
{
    case general(errCode: Int, data: [String: Any])
    case badRequest(errCode: Int, description: String)
    case badResponseData(errCode: Int, data: [String: Any])
    case userNotExists(errCode: Int, description: String)
    case invalidResponseStatusCode(errCode: Int, description: String)
    case captchaRequired(errCode: Int, data: [String: Any])
    case wrongCaptcha(errCode: Int, description: String)
    case invalidInputParameter(name: String, description: String)
    case invalidObject(objType: String, description: String)
    case unfinishedAuthorization(trackId: String?, xToken: String?, innerErr: Error?)
    case invalidToken(description: String)
    case invalidBitrate(description: String)
    case trackDownloadInfoNotExists(description: String)
    case trackDownloadLinkDead(description: String)
}
