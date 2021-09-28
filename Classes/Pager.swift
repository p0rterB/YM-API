//
//  Pager.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Represents objects set paginator
public class Pager: Decodable {
    
    ///Total objects count
    public let total: Int
    ///Page number
    public let page: Int
    ///Objects count on page
    public let perPage: Int
    
    public init(total: Int, page: Int, perPage: Int) {
        self.total = total
        self.page = page
        self.perPage = perPage
    }
}
