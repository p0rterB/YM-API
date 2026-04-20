//
//  Headline.swift
//  YM-API
//
//  Created by Developer on 30.07.2021.
//

import Foundation

///Represents feed headline object
public class Headline: Decodable {
    ///Headline ID
    public let id: String
    ///Headline object type
    public let type: String
    ///Headline message
    public let message: String
    
    public init(id: String, type: String, message: String) {
        self.id = id
        self.type = type
        self.message = message
    }
}
