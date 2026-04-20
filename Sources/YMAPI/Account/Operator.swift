//
//  Operator.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents cell provider service
public class Operator: Decodable {
    
    ///Yandex Music service UID
    public let product_id: String
    ///Mobile phone number for service link
    public let phone: String
    ///Service payment regularity
    public let payment_regularity: String
    ///Service deactivation methods
    public let deactivation: [Deactivation]
    ///Service title
    public let title: String
    ///Service suspended marker
    public let suspended: Bool
    
    
    
    public init(product_id: String, phone: String, payment_regularity: String, deactivation: [Deactivation], title: String, suspended: Bool) {
        self.product_id = product_id
        self.phone = phone
        self.payment_regularity = payment_regularity
        self.deactivation = deactivation
        self.title = title
        self.suspended = suspended

        
    }
}
