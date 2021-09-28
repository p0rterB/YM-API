//
//  TrackBitrate.swift
//  YM-API
//
//  Created by Developer on 25.08.2021.
//

import Foundation

public enum TrackBitrate: UInt8 {
    case kbps_64
    case kbps_128
    case kbps_192
    case kbps_320
}

extension TrackBitrate {
    public var value: Int {
        get {
            switch (self) {
            case .kbps_64: return 64
            case .kbps_128: return 128
            case .kbps_192: return 192
            case .kbps_320: return 320
            }
        }
    }
    
    public var valueString: String {
        get {return String(value)}
    }
}
