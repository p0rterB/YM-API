//
//  Link.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Artist official link
public class Link: Decodable {
    
    //Note: Известные типы страниц: `official` - официальный сайт и `social` - социальная сеть.
    
    ///Page title
    public let title: String
    ///Page url
    public let href: String
    ///Link type
    public let type: String
    ///Social network name
    public let socialNetwork: String?
    
    public init(title: String, href: String, type: String, socialNetwork: String?) {
        self.title = title
        self.href = href
        self.type = type

        self.socialNetwork = socialNetwork
    }
}
