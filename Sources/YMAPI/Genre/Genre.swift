//
//  Genre.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Music genre
public class Genre: Decodable {
    
    ///Genre UID
    public let id: String
    ///Genre weight TODO (possible higher weight = user likes)
    public let weight: Int
    ///TODO
    public let composerTop: Bool
    ///Genre title
    public let title: String
    ///Fulle genre title
    public let fullTitle: String?
    ///Genre title localizations
    public let titles: [String: GenreTitle?]
    ///Genre images
    public let images: GenreImage?
    ///Show genre in the menu
    public let showInMenu: Bool
    ///regions list, where current genre is available
    public let showInRegions: [Int]?
    ///Genre part url
    public let urlPart: String?
    ///Genre image background color
    public let color: String?
    ///Genre radio icon
    public let radioIcon: Icon?
    ///Related subgenres of current genre
    public let subGenres: [Genre]?
    ///List of regions, where current genre is hidden
    public let hideInRegions: [Int]?
    
    public init(id: String,
                weight: Int,
                composerTop: Bool,
                title: String,
                titles: [String: GenreTitle?],
                images: GenreImage?,
                showInMenu: Bool,
                showInRegions: [Int]?,
                fullTitle: String?,
                urlPart: String?,
                color: String?,
                radioIcon: Icon?,
                subGenres: [Genre]?,
                hideInRegions: [Int]?) {
        self.id = id
        self.weight = weight
        self.composerTop = composerTop
        self.title = title
        self.titles = titles
        self.images = images
        self.showInMenu = showInMenu

        self.showInRegions = showInRegions
        self.fullTitle = fullTitle
        self.urlPart = urlPart
        self.color = color
        self.radioIcon = radioIcon
        self.subGenres = subGenres
        self.hideInRegions = hideInRegions
    }
}
