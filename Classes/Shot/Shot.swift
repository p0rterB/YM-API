//
//  Shot.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Alisa's shot
public class Shot: Decodable {
    
    ///Order number during playing
    public let order: Int
    ///Played shot marker
    public let played: Bool
    ///General information about shot
    public let shotData: ShotData
    ///Alisa's shot UID
    public let shotId: String
    ///Shot status
    public let status: String

    public init(order: Int, played: Bool, shotData: ShotData, shotId: String, status: String) {
        self.order = order
        self.played = played
        self.shotData = shotData
        self.shotId = shotId
        self.status = status
    }
}
