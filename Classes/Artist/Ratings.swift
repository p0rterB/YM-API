//
//  Rating.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents artist rating
public class Ratings: Decodable {
    
    ///Montly rating value
    public let month: Int
    ///Weekly rating value
    public let week: Int?
    ///Daily rating value
    public let day: Int?

    public init(month: Int, week: Int?, day: Int?) {
        self.week = week
        self.month = month

        self.day = day
    }
}
