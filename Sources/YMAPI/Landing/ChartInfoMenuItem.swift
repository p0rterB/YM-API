//
//  ChartInfoMenuItem.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents chart menu item
public class ChartInfoMenuItem: Decodable {
    
    ///Item title
    public let title: String
    ///Chart reqeust postfix
    public let url: String
    ///'Current element' marker
    public let selected: Bool?

    public init(title: String, url: String, selected: Bool?) {
        self.title = title
        self.url = url
        self.selected = selected
    } 
}
