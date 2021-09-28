//
//  MadeFor.swift
//  YM-API
//
//  Created by Developer on 03.06.2021.
//

import Foundation

///Back-end generated playlist for user
public class PlaylistFor: Decodable {
    
    ///Information about user
    public let userInfo: User?
    ///User name cases
    public let caseForms: CaseForms?

    public init (userInfo: User?, caseForms: CaseForms?) {
        self.userInfo = userInfo
        self.caseForms = caseForms
    }
}
