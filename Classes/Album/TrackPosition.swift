//
//  TrackPosition.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents track position number at parent album
public class TrackPosition: Decodable {
    //Note: Позиция трека в альбоме, который возвращается при получении самого трека. Volume на фронте именуется как "Диск".
    
    ///Album volume number
    public let volume: Int
    ///Track index
    public let index: Int

    public init(volume: Int, index: Int) {
        self.volume = volume
        self.index = index
    }
}
