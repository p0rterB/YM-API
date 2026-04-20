//
//  Settings.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///In-app buy suggestions
public class PurchaseSuggestions: Decodable {
    
    ///Selling in-app products
    public let inAppProducts: [Product]
    ///Selling products (show by banners)
    public let nativeProducts: [Product]
    ///Payment url
    public let webPaymentUrl: String
    ///Product cost for a month
    public let webPaymentMonthProductPrice: Price?
    ///Promo codes available marker
    public let promoCodesEnabled: Bool

    public init(inAppProducts: [Product], nativeProducts: [Product], webPaymentUrl: String, promoCodesEnabled: Bool, webPaymentMonthProductPrice: Price?) {
        self.inAppProducts = inAppProducts
        self.nativeProducts = nativeProducts
        self.webPaymentUrl = webPaymentUrl
        self.webPaymentMonthProductPrice = webPaymentMonthProductPrice
        self.promoCodesEnabled = promoCodesEnabled

        
    }
        
}
