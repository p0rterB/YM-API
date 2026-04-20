//
//  ChartInfo.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents chart info
public class ChartList: Decodable {
    
    ///Chart UID
    public let id: String
    ///Chart type
    public let type: String
    ///Chart source
    public let typeForFrom: String
    ///Chart title
    public let title: String
    ///Chart items list
    public let menu: ChartInfoMenu?
    ///Playlist data in chart
    public let chart: Playlist?
    ///Chart description
    public let chartDescription: String?
    
    public init(id: String, type: String, typeForFrom: String, title: String, menu: ChartInfoMenu?, chart: Playlist?, chartDescription: String?) {
        self.id = id
        self.type = type
        self.typeForFrom = typeForFrom
        self.title = title

        self.menu = menu
        self.chart = chart
        self.chartDescription = chartDescription
    }
}
