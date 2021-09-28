//
//  StationTracksResult.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Radio station tracks sequence
public class StationTracksResult: Decodable {
    
    ///Radio station ID
    public let id: RadioId?
    ///Radio station tracks sequence
    public let sequence: [RadioSequence]
    ///Tracks sequence ID
    public let batchId: String
    ///Haloween
    public let pumpkin: Bool

    public init(id: RadioId?, sequence: [RadioSequence], batchId: String, pumpkin: Bool) {
        self.id = id
        self.sequence = sequence
        self.batchId = batchId
        self.pumpkin = pumpkin
    }
}
