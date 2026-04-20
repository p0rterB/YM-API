//
//  Vinyl.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents artist vinyl
public class Vinyl: Decodable {
    
    ///Vinyl store purchase url
    public let url: String
    ///Vinyl title
    public let title: String
    ///Vinyl release year
    public let year: Int
    ///Vinyl price
    public let price: Int
    ///Media source
    public let media: String
    ///Vinyl buy offer UID
    public let offerId: Int
    ///Artists UIDs
    public let artistIds: [Int]?
    ///Vinyl cover image url
    public let picture: String?

    public init(url: String, title: String, year: Int, price: Int, media: String, offerId: Int, artistIds: [Int]?, picture: String?) {
        self.url = url
        self.picture = picture
        self.title = title
        self.year = year
        self.price = price
        self.media = media
        self.offerId = offerId
        self.artistIds = artistIds
    }
}
