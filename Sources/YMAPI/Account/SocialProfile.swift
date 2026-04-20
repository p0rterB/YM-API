//
//  SocialProfile.swift
//  YM-API
//
//  Created by Developer on 12.05.2022.
//

import Foundation

///Represents user social profiles info
public class SocialProfile: Decodable {
    
    public let provider: String
    public let addresses: [String]
    
    public init(provider: String, addresses: [String]) {
        self.provider = provider
        self.addresses = addresses
    }
}
