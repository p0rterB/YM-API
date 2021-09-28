//
//  Chart.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents chart element object
public class Chart: Decodable {
    //Note:Смещение - это количество позиций, на которые трек поднялся или опустился в чарте.
    
    ///Item position in the chart
    public let position: Int
    ///TODO
    public let progress: String
    ///Listeners count
    public let listeners: Int
    ///Item position shift count
    public let shift: Int
    ///Background color
    public let bgColor: String?
    ///Track UID
    public let trackId: TrackId?

    public init(position: Int, progress: String, listeners: Int, shift: Int, bgColor: String?, trackId: TrackId?) {
        self.position = position
        self.progress = progress
        self.listeners = listeners
        self.shift = shift

        self.bgColor = bgColor
        self.trackId = trackId
    }
}
