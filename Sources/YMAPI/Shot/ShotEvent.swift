//
//  ShotEvent.swift
//  YM-API
//
//  Created by Developer on 25.05.2021.
//

///Shot-event before starting new track
public class ShotEvent: Decodable {
    
    ///Shot event UID
    public let eventId: String
    ///Shots from Alisa
    public let shots: [Shot]

    public init(eventId: String, shots: [Shot]) {
        self.eventId = eventId
        self.shots = shots
    }
}
