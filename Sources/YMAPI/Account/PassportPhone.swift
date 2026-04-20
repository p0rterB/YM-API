//
//  PassportPhone.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represent user phone number
public class PassportPhone: Decodable {
    
    ///Phone number
    public let phone: String

    public init(phone: String) {
        self.phone = phone
    }
}
