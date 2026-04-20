//
//  StationData.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Represents personal radio station info
public class StationData: Decodable {
    
    ///Name of the personal radio station
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}
