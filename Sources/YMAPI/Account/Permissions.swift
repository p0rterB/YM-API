//
//  Permissions.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents user permissions, its values and end dates
public class Permissions: Decodable {
 
    ///Permissions end date
    public let until: String
    ///Permissions list
    public let values: [String]
    ///Permissions default values
    public let `default`: [String]
    
    public init(until: String, values: [String], defaultValues: [String]) {
        self.until = until
        self.values = values
        self.default = defaultValues
    }
}
