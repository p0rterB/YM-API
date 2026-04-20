//
//  PermissionAlert.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represents notifications
public class PermissionAlert: Decodable {
    
    ///Notifications list
    public let alerts: [String]
    
    public init(alerts: [String]) {
        self.alerts = alerts
    }
}
