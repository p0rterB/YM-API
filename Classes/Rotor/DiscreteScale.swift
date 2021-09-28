//
//  DiscreteScale.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Rerpesenets Discrete value
public class DiscreteScale: Decodable {
    
    ///Type of discrete value
    public let type: String
    ///Name of discrete value
    public let name: String
    ///Minimum value
    public let min: KeyValueObj?
    ///Maximum value
    public let max: KeyValueObj?

    public init(type: String, name: String, min: KeyValueObj?, max: KeyValueObj?) {
        self.type = type
        self.name = name
        self.min = min
        self.max = max
    }
}
