//
//  Id.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Radio station identificator
public class RadioId: Decodable {
    ///Radio station type
    public let type: String
    ///Radio station tag
    public let tag: String
    
    ///Combined data - radio station ID
    public var stationId: String {
        get {return type + ":" + tag}
    }

    public init(type: String, tag: String) {
        self.type = type
        self.tag = tag
    }
}
