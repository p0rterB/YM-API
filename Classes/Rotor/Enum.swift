//
//  Enum.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Represents enums
public class Enum: Decodable {
    
    ///Enum type
    public let type: String
    ///Enum name
    public let name: String
    ///Available values
    public let possibleValues: [KeyValueObj]
    
    public init(type: String, name: String, possibleValues: [KeyValueObj]) {
        self.type = type
        self.name = name
        self.possibleValues = possibleValues
    }
}
