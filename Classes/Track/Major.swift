//
//  Major.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

import Foundation

///Major-label track
public class Major: Decodable {
    public let id: Int
    public let name: String
    public let prettyName: String?

    public init(id: Int, name: String, prettyName: String?)
    {
        self.id = id
        self.name = name
        self.prettyName = prettyName
    }
}
