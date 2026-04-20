//
//  RotorSettings.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

public class RotorSettings: Decodable {
    // Note: Поля `energy`, `mood` используются в старых настройках (`settings1`). Значения `mood_energy`: `fun`, `active`, `calm`, `sad`, `all`. Значения `diversity`: `favorite`, `popular`, `discover`, `default`. Значения `language`: `not-russian`, `russian`, `any`.
    
    public let language: String
    ///Diversity of possible tracks
    public let diversity: String
    ///Legacy option of tracks' 'mood'
    public let mood: Int?
    ///Option of tracks' energy
    public let energy: Int?
    ///Option of tracks mood
    public let moodEnergy: String?
    
    public init(language: String, diversity: String, mood: Int?, energy: Int?, moodEnergy: String?) {
        self.language = language
        self.diversity = diversity

        self.mood = mood
        self.energy = energy
        self.moodEnergy = moodEnergy
    }
}
