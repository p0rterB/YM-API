//
//  Tag.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represents tag (set)
public class Tag: Decodable {
    
    ///Tag UID
    public let id: String
    ///Tag value (name in lower case)
    public let value: String
    ///Tag name (display name)
    public let name: String?
    ///Tag description for Open Graph
    public let ogDescription: String?
    ///Open Graph image url
    public let ogImage: String?

    public init(id: String, value: String, name: String, ogDescription: String, ogImage: String?) {
        self.id = id
        self.value = value
        self.name = name
        self.ogDescription = ogDescription

        self.ogImage = ogImage
    }
}
