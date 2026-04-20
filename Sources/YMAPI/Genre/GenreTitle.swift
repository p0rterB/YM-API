//
//  GenreTitle.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents genre title info
public class GenreTitle: Decodable {
    
    ///Head title
    public let title: String
    ///Full head title
    public let fullTitle: String?
    
    public init(title: String, fullTitle: String?) {
        self.title = title
        self.fullTitle = fullTitle
    }
}
