//
//  ChartInfoMenu.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents chart menu
public class ChartInfoMenu: Decodable {
    
    ///Menu elements list
    public let items: [ChartInfoMenuItem]
    
    public init(items: [ChartInfoMenuItem]) {
        self.items = items
    }
}
