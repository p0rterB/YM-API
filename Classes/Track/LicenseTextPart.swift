//
//  LicenseTextPart.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Part of text with license agreement url
public class LicenceTextPart: Decodable {
    
    ///Part of the text (line)
    public let text: String
    ///License agreement url
    public let url: String

    public init(text: String, url: String) {
        self.text = text
        self.url = url
    }
}
