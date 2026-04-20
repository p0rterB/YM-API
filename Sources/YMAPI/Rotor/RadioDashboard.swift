//
//  RadioDashboard.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Recommended for user radio stations
public class RadioDashboard: Decodable {
    
    ///Dashboard UID
    public let dashboardId: String
    ///List of radio station with settings and preferences
    public let stations: [StationResult]
    ///Haloween
    public let pumpkin: Bool
    
    public init(dashboardId: String, stations: [StationResult], pumpkin: Bool) {
        self.dashboardId = dashboardId
        self.stations = stations
        self.pumpkin = pumpkin
    }
}
