//
//  Device.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents device info for requests
public class YMDevice {
    
    enum CodingKeys: String, CodingKey {
        case os
        case osVersion = "os_version"
        case manufacturer
        case name
        case platform
        case model
        case clid
        case deviceId = "device_id"
        case uuid
    }
    
    ///Device operating system name (Android, iOS and others)
    public let os: String
    ///OS version
    public let osVersion: String
    ///Device manufacturer name (Apple, Samsung and others)
    public let manufacturer: String
    ///Device name
    public let name: String
    ///Device platform
    public let platform: String
    ///Device platform API key
    public var apiPlatform: String {
        get {
            let lowercased = platform.lowercased()
            if (lowercased.contains("android")) {
                return "android"
            }
            if (lowercased == "ios" || lowercased == "iphone") {
                return "ios"
            }
            return "android"
        }
    }
    ///Device model name
    public let model: String
    ///Device app client ID (google-play, for example)
    public let clid: String
    ///Device ID (32 bytes)
    public let deviceId: String
    ///Universally unique identifier (32 bytes)
    public let uuid: String
    
    ///Serialized object data for reqeust header
    public var deviceHeader: String {
        get {            
            let dict: [String: String] = [
                CodingKeys.os.stringValue: os,
                CodingKeys.osVersion.stringValue: osVersion,
                CodingKeys.manufacturer.stringValue: manufacturer,
                CodingKeys.model.stringValue: model,
                CodingKeys.clid.stringValue: clid,
                CodingKeys.uuid.stringValue: uuid,
                CodingKeys.deviceId.stringValue: deviceId
            ]
            return dict.map({ "\($0.key)=\($0.value)" }).joined(separator: "; ")
        }
    }
    
    public init(os: String, osVer: String, manufacturer: String, name: String, platform: String, model: String, clid: String, deviceId: String, uuid: String) {
        self.os = os
        self.osVersion = osVer
        self.name = name
        self.platform = platform
        self.model = model
        self.manufacturer = manufacturer
        self.clid = clid
        self.deviceId = deviceId
        self.uuid = uuid
    }
}
