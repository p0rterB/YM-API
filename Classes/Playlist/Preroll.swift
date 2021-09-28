//
//  Preroll.swift
//  YM-API
//
//  Created by Developer on 26.07.2021.
//

import Foundation

///Playable content before main payload
public class Preroll: Decodable {
    ///Pre-roll ID
    public let id: String?
    ///Pre-roll source link
    public let link: String?
    
    public init(id: String?, link: String?) {
        self.id = id
        self.link = link
    }
}
