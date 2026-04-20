//
//  Feed.swift
//  YM-API
//
//  Created by Developer on 04.06.2021.
//

import Foundation

///Represents feed
public class Feed: Decodable {
 
    ///More events marker
    public let canGetMoreEvents: Bool
    ///Haloween
    public let pumpkin: Bool
    ///TODO
    public let isWizardPassed: Bool
    ///Generated playlists for feed
    public let generatedPlaylists: [GeneratedPlaylist]
    ///Feed headlines
    public let headlines: [Headline]
    ///Today date ('YYYY-MM-DD' format)
    public let today: String
    ///Feed days
    public let days: [FeedDay]
    ///Date of next feed revision ('YYYY-MM-DD' format)
    public let nextRevision: String?
    
    public init(canGetMoreEvents: Bool,
                pumpkin: Bool,
                isWizardPassed: Bool,
                generatedPlaylists: [GeneratedPlaylist],
                headlines: [Headline],
                today: String,
                days: [FeedDay],
                nextRevision: String?) {
        self.canGetMoreEvents = canGetMoreEvents
        self.pumpkin = pumpkin
        self.isWizardPassed = isWizardPassed
        self.generatedPlaylists = generatedPlaylists
        self.headlines = headlines
        self.today = today
        self.days = days

        self.nextRevision = nextRevision
    }
}
