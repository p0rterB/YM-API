//
//  RadioSequence.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Radio track sequence item
public class RadioSequence: Decodable {
    
    //Note: Известные значения поля `type_`: `track`. Возможно, есть `ad`.
    
    ///Seqeunce type
    public let type: String
    ///Sequence track info
    public let track: Track?
    ///Track linked marker
    public let liked: Bool
    
    public init(type: String, track: Track?, liked: Bool) {
        self.type = type
        self.track = track
        self.liked = liked
    }
}
