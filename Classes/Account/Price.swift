//
//  Price.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents service price
public class Price: Decodable {
    
    ///Service price amoum
    public let amount: Int
    ///Price currency
    public let currency: String

    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency

        
    }
}
