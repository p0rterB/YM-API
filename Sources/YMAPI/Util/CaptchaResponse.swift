//
//  CaptchaResponse.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Server response type with inputting captcha
public class CaptchaResponse: Decodable {
    
    ///Captcha image url
    public let x_captcha_url: String
    ///Captcha UID
    public let x_captcha_key: String
    ///Error description
    public let error_description: String
    ///Error code
    public let error: String
    
    public init(x_captcha_url: String, x_captcha_key: String, errDesc: String, errCode: String) {
        self.x_captcha_url = x_captcha_url
        self.x_captcha_key = x_captcha_key
        self.error_description = errDesc
        self.error = errCode
    }
    
    ///Download captcha image
    public func downloadCaptchaImg(completion: @escaping (Result<Data, YMError>) -> Void) {
        download(fullPath: x_captcha_url, completion: completion)
    }
}
