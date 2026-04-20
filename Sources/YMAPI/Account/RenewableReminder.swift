//
//  RenewableReminder.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Subscription renew reminder
public class RenewableReminder: Decodable {
    
    ///Subscription days left before end
    public let days: Int

    public init(days: Int) {
        self.days = days
    }
}
