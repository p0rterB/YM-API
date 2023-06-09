//
//  TrackBitrate.swift
//  YM-API
//
//  Created by Developer on 25.08.2021.
//

import Foundation

public enum TrackBitrate: UInt16 {
    case kbps_64 = 64
    case kbps_128 = 128
    case kbps_192 = 192
    case kbps_256 = 256
    case kbps_320 = 320
}

extension TrackBitrate {
    
    public var valueString: String {
        get {return String(self.rawValue)}
    }
}
