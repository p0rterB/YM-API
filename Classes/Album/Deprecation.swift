//
//  Deprecation.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents TODO
public class Deprecation: Decodable {
    
    ///Album target UID TODO
    public let targetAlbumId: Int?
    ///Depreaction state TODO
    public let status: String?
    ///Deprecatrion process done marker TODO
    public let done: Bool?
    
    public init(targetAlbumId: Int?, status: String?, done: Bool?) {
        self.targetAlbumId = targetAlbumId
        self.status = status
        self.done = done
    }
}
