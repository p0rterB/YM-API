//
//  TrackCodecs.swift
//  YM-API
//
//  Created by Developer on 25.08.2021.
//

import Foundation

public enum TrackCodec: UInt8 {
    case mp3
    case aac
}

extension TrackCodec {
    public var codecType: String {
        get {
            switch self {
            case .mp3: return "mp3"
            case .aac: return "aac"
            }
        }
    }
}
