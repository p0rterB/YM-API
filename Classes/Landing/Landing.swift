//
//  Landing.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents landing
public class Landing: Decodable {
    
    ///Haloween marker
    public let pumpkin: Bool
    ///Content UID
    public let contentId: String
    ///Landing blocks
    public let blocks: [Block]

    public init(pumpkin: Bool, contentId: String, blocks: [Block]) {
        self.pumpkin = pumpkin
        self.contentId = contentId
        self.blocks = blocks
    }
    
    public func getItem(index: Int) -> Block {
        return blocks[index]
    }
}
