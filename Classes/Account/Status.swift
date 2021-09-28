//
//  Status.swift
//  YM-API
//
//  Created by Developer on 11.06.2021.
//

import Foundation

///Represents detailed user account information
public class Status: Decodable {
    
    ///Account info
    public let account: Account?
    ///User permissions
    public let permissions: Permissions?
    ///Ads text
    public let advertisement: String?
    ///Subscription info
    public let subscription: Subscription?
    ///Cached tracks maximum count (active in premium)
    public let cacheLimit: Int?
    ///Information checker (moderator) status marker
    public let subeditor: Bool?
    ///Moderator level
    public let subeditorLevel: Int?
    ///Plus subscription info
    public let plus: PlusSubscription?
    ///User main email
    public let defaultEmail: String?
    ///Radio tracks skips per hour (maximum count)
    public let skipsPerHour: Int?
    ///Personal station existance marker
    public let stationExists: Bool?
    ///Personal station information
    public let stationData: StationData?
    ///Block with alert below (subscription ends, gifts etc)
    public let barBelow: Alert?
    ///Region TODO
    public let premiumRegion: Int?
    ///Test feature ID TODO
    public let experiment: Int?
    
    public init(account: Account?,
                permissions: Permissions?,
                advertisement: String?,
                subscription: Subscription?,
                cacheLimit: Int?,
                subeditor: Bool?,
                subeditorLevel: Int?,
                plus: PlusSubscription?,
                defaultEmail: String?,
                skipsPerHour: Int?,
                stationExists: Bool?,
                stationData: StationData?,
                barBelow: Alert?,
                premiumRegion: Int?,
                experiment: Int?) {
        self.account = account
        self.permissions = permissions

        self.advertisement = advertisement
        self.subscription = subscription
        self.cacheLimit = cacheLimit
        self.subeditor = subeditor
        self.subeditorLevel = subeditorLevel
        self.plus = plus
        self.defaultEmail = defaultEmail
        self.skipsPerHour = skipsPerHour
        self.stationExists = stationExists
        self.stationData = stationData
        self.barBelow = barBelow
        self.premiumRegion = premiumRegion
        self.experiment = experiment
    }
}
