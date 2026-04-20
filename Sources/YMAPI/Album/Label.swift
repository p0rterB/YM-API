//
//  Label.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents album label
public class Label: Decodable {
    
    ///Album UID
    public let id: Int
    ///Album name
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
