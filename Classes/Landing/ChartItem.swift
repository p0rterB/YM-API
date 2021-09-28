//
//  ChartItem.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represent track in the chart
public class ChartItem: YMBaseObject, Decodable {
    
    ///Chart track info
    public let track: Track?
    ///Chart element
    public let chart: Chart?

    public init(track: Track?, chart: Chart?) {
        self.track = track
        self.chart = chart
    }
}
