//
//  OpenGraphData.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Data provider  for Open Graph
public class OpenGraphData: Decodable {
    
    ///Head title
    public let title: String
    ///Data description
    public let description: String
    public let image: Cover

    public init(title: String, description: String, image: Cover) {
        self.title = title
        self.description = description
        self.image = image
    }
}
