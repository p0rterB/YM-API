//
//  PlayCounter.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Days counter (for playliists)
public class PlayCounter: Decodable {
    
    ///Counter value (count of days)
    public let value: Int
    ///Counter description
    public let description: String
    ///'Is there the update for today?' marker
    public let updated: Bool

    public init(value: Int, description: String, updated: Bool) {
        self.value = value
        self.description = description
        self.updated = updated
    }
}
