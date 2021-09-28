//
//  NonRenewable.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents non renewable state of subscription
public class NonRenewable: Decodable {
    
    ///Subscription begin date
    public let start: String
    ///Subscription end date
    public let end: String
    
    public init(start: String, end: String) {
        self.start = start
        self.end = end

        
    }
 }
