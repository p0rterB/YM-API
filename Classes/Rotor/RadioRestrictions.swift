//
//  Restrictions.swift
//  YM-API
//
//  Created by Developer on 26.05.2021.
//

import Foundation

///Radio station restrictions settings
public class RadioRestrictions: Decodable {
    
    ///Available languages enum
    public let language: Enum?
    ///Available diversity values (for tracks)
    public let diversity: Enum?
    ///Track mood measure restrictions
    public let mood: DiscreteScale?
    ///Track energy measure restrictions
    public let energy: DiscreteScale?
    ///Available mood values
    public let moodEnergy: Enum?
    
    public init(language: Enum?, diversity: Enum?, mood: DiscreteScale?, energy: DiscreteScale?,  moodEnergy: Enum?) {
        self.language = language
        self.diversity = diversity
        self.mood = mood
        self.energy = energy
        self.moodEnergy = moodEnergy
    }
}
