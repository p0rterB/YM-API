//
//  PromoCodeStatus.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

///Promo code activation status
public class PromoCodeStatus: Decodable {
    
    ///Operation status
    public let status: String
    ///Operation status description
    public let statusDesc: String
    ///user account info
    public let accountStatus: Status?
    
    public init(status: String, statusDesc: String, accountStatus: Status?) {
        self.status = status
        self.statusDesc = statusDesc
        self.accountStatus = accountStatus
    }
}
