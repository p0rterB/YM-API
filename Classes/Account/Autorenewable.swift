//
//  Autorenewable.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Renewable subscription information
public class Autorenewable: Decodable {
    
    ///Subscription expires date
    public let expires: String
    ///Subscription seller
    public let vendor: String
    ///Seller help url
    public let vendor_help_url: String
    ///Subscription product
    public let product: Product?
    ///Renewable diabled state marker
    public let finished: Bool
    ///Multy user subscription master account
    public let master_info: User?
    ///Product UID
    public let product_id: String?
    ///Order UID
    public let order_id: Int?

    public init(expires: String, vendor: String, vendor_help_url: String, product: Product?, finished: Bool, master_info: User?, product_id: String?, order_id: Int?) {
        self.expires = expires
        self.vendor = vendor
        self.vendor_help_url = vendor_help_url
        self.product = product
        self.finished = finished

        self.master_info = master_info
        self.product_id = product_id
        self.order_id = order_id
    }
}
